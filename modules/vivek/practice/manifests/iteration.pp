class practice::iteration {
  $tasks = ['task1', 'task2', 'task3', 'task4', 'task5', 'task6']
  $tasks.each | $task | {
    file { "/tmp/${task}":
      content => "echo I am ${task}\n",
      mode    => '0766',
    }
  }
}
