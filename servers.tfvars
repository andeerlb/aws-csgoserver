# Define all your CS2 servers here

servers = {
  # Server 1 - Uses default instance type (t3a.medium)
  server1 = {
    server_name   = ""
    gslt_token    = ""
    rcon_passwd   = ""
    server_passwd = ""
    ssh_key_pair  = ""
    # instance_type = "t3a.medium"  # Optional - defaults to t3a.medium if not specified
  }

  # Server 2 - Custom instance type for better performance
  # server2 = {
  #   server_name   = ""
  #   gslt_token    = ""
  #   rcon_passwd   = ""
  #   server_passwd = ""
  #   ssh_key_pair  = ""
  #   instance_type = "t3a.large"  # Larger instance for more players
  # }

  # Server 3 - Example with small instance
  # server3 = {
  #   server_name   = ""
  #   gslt_token    = ""
  #   rcon_passwd   = ""
  #   server_passwd = ""
  #   ssh_key_pair  = ""
  #   instance_type = "t3a.small"  # Smaller/cheaper instance
  # }
}
