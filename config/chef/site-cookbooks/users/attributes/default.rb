node.default['users'] = {
  'admin' => {
    password: '$1$FSI/lFYT$3e6gTONJkSA11pQHwFAqz.',
    manage_home: true,
    ssh_authorized_keys: true
  },
  'web' => {
    password: '$1$FSI/lFYT$3e6gTONJkSA11pQHwFAqz.',
    manage_home: true,
    ssh_authorized_keys: true
  },
  'docker' => {
    password: '$1$FSI/lFYT$3e6gTONJkSA11pQHwFAqz.',
    manage_home: false,
    ssh_authorized_keys: true
  }
}

node.default['groups'] = {
  'admin' => %w(admin),
  'deploy' => %w(web docker)
}

node.default['sudoers'] = {
  '%admin' => 'ALL = NOPASSWD: ALL'
}

