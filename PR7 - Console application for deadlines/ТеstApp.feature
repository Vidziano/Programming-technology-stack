require_relative 'C:\Projects\Barbinov_PR7.rb' # Залежить від структури вашого проекту

Given('I have an empty task manager') do
@task_manager = TaskManager.new
end

Given('I have a task with title {string} and deadline {string}') do |title, deadline|
@task_manager ||= TaskManager.new
@task_manager.add_task(title, deadline)
end

When('I add a task with title {string} and deadline {string}') do |title, deadline|
@task_manager.add_task(title, deadline)
end

Then('I should see the task with title {string} in the task list') do |title|
task_titles = @task_manager.display_tasks.map(&:title)
expect(task_titles).to include(title)
end

When('I save tasks to file') do
@task_manager.save_tasks
end

Then('the file {string} should contain the task with title {string}') do |file, title|
data = JSON.parse(File.read(file))
titles_in_file = data.map { |task| task['title'] }
expect(titles_in_file).to include(title)
end

Given('the file {string} contains a task with title {string} and deadline {string}') do |file, title, deadline|
data = [{ 'title' => title, 'deadline' => deadline, 'completed' => false, 'comment' => '', 'priority' => 'середній' }]
File.write(file, JSON.pretty_generate(data))
end

When('I load tasks from file') do
@task_manager.load_tasks
end

When('I filter tasks by date {string}') do |date|
@filtered_tasks = @task_manager.display_filtered_tasks(deadline: date)
end

Then('I should see only one task with title {string} in the filtered list') do |title|
expect(@filtered_tasks.size).to eq(1)
expect(@filtered_tasks[0].title).to eq(title)
end

When('I edit the task with title {string} to have title {string} and deadline {string}') do |old_title, new_title, new_deadline|
index = @task_manager.display_tasks.find_index { |task| task.title == old_title }
@task_manager.edit_task(index, new_title, new_deadline)
end

Then('the task deadline should be {string}') do |expected_deadline|
expect(@task_manager.display_tasks[0].deadline.strftime("%Y-%m-%d")).to eq(expected_deadline)
end
