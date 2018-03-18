class Slurm < Package
  url 'https://download.schedmd.com/slurm/slurm-17.11.5.tar.bz2'
  sha256 '39f5c53bc101909494c4abc1fb47a8cd86cba16ec77503aa9e994c11bef7f01d'

  label :common

  depends_on :openssl
  depends_on :munge

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{link_root}/etc
      --with-munge=#{Munge.link_root}
      --with-ssl=#{Openssl.link_root}
      --with-hdf5=no
    ]
    run './configure', *args
    run 'make', '-j', '8'
    run 'make', 'check'
    run 'make', 'install'
  end

  def post_install
    # Create slurm system user.
    OS.add_user 'slurm', system_user: true, all_nodes: true
    # Generate slurm.conf file.
    conf_file = "#{link_root}/etc/slurm.conf"
    if not File.exist? conf_file
      write_file conf_file, <<-EOS
ClusterName=cluster
ControlMachine=#{Settings.master_node}
ControlAddr=#{Settings.master_node}
SlurmUser=slurm
SlurmctldPort=6817
SlurmdPort=6818
AuthType=auth/munge
StateSaveLocation=/var/spool/slurm/ctld
SlurmdSpoolDir=/var/spool/slurm/d
SwitchType=switch/none
MpiDefault=none
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmdPidFile=/var/run/slurmd.pid
ProctrackType=proctrack/cgroup
SlurmctldTimeout=300
SlurmdTimeout=300
InactiveLimit=0
MinJobAge=300
KillWait=30
Waittime=0
SchedulerType=sched/backfill
FastSchedule=1
SlurmctldDebug=3
SlurmctldLogFile=/var/log/slurmctld.log
SlurmdDebug=3
SlurmdLogFile=/var/log/slurmd.log
JobCompType=jobcomp/none
NodeName=#{Settings.nodes} Procs=1 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOS
    end
    CLI.warning "You should revise #{CLI.red conf_file} before start slurm."
  end
end
