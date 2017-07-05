if Rails.env.development?
  electrician = Role.find_or_create_by name: 'Electrician'
  operator = Role.find_or_create_by name: 'Operator'
  visitor = Role.find_or_create_by name: 'Visitor'

  user1 = User.find_or_create_by token: '954179576-sOBnNZ43Kr7aOmUQQF2s5jbFt9JUo9zIrYHnNlb6', secret: 'ftogLNPnes6lZpkAne4su1ypTXugFM8cLcpL4HBQF9Z03', provider: 'twitter', uid: '954179576', name: 'John Wesly', username: 'waldouribe', role: 'admin'

  user2 = User.find_or_create_by token: '722533485412532224-FzLeMgX8R1tTqS5MqjE3E2XLhTSfyB8', secret: '6erAmhtVk4BtDsmabREnd4APPHdAMSO5Lpr9DUeNNJruB', provider: 'twitter', uid: '722533485412532224', name: 'Frank Jenson', username: 'waldouribe', role: 'worker'

  p1 = MyProcess.find_or_create_by name: "Residential electricity maintenance", hashtag: 'rem_5412', user: user1
  p2 = MyProcess.find_or_create_by name: "Industrial electricity maintenance", hashtag: 'iem_427', user: user1
  p3 = MyProcess.find_or_create_by name: "Residential electricity instalations", hashtag: 'rei_87', user: user1

  t1 = p1.tasks.find_or_create_by(address: 'Los Dominicos 8630, Las Condes', name: 'Measure electricity usage', priority: 1)
  t2 = p1.tasks.find_or_create_by(address: 'Vitacura 6440, Vitacura', name: 'Measure electricity usage', priority: 2)
  t3 = p1.tasks.find_or_create_by(address: 'Francisco de Villagra 6664, La Reina', name: 'Restore electricity', priority: 3)
  t4 = p1.tasks.find_or_create_by(address: 'Rojas Magallanes 1400, La Florida', name: 'Shut down electricity', priority: 4)
  t4 = p1.tasks.find_or_create_by(address: 'Las tinajas 4000, La Florida', name: 'Measure electricity usage', priority: 5)

  t1 = p2.tasks.find_or_create_by(address: 'Los Dominicos 8630, Las Condes', name: 'Turn off generator', priority: 1)
  t2 = p2.tasks.find_or_create_by(address: 'Vitacura 6440, Vitacura', name: 'Replace AD-450 cable', priority: 2)
  t3 = p2.tasks.find_or_create_by(address: 'Vitacura 6440, Vitacura', name: 'Replace FH-04 cable', priority: 2)
  t4 = p2.tasks.find_or_create_by(address: 'Vitacura 6440, Vitacura', name: 'Clean F-20 board', priority: 3)
  t5 = p2.tasks.find_or_create_by(address: 'Los Dominicos 8630, Las Condes', name: 'Turn on generator', priority: 4)
  t6 = p2.tasks.find_or_create_by(address: 'Los Dominicos 8630, Las Condes', name: 'Check status', priority: 5)

  Waiting.find_or_create_by(task: t2, waiting: t1)
  Waiting.find_or_create_by(task: t3, waiting: t1)
  Waiting.find_or_create_by(task: t4, waiting: t2)
  Waiting.find_or_create_by(task: t4, waiting: t3)
  Waiting.find_or_create_by(task: t5, waiting: t4)
  Waiting.find_or_create_by(task: t6, waiting: t5)
end