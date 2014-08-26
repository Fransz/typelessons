theTaskModel = new TaskModel
    letters: ['g', 'h']

theTaskView = new TaskView
    model: theTaskModel

theExamModel = new ExamModel
    letters: ['g', 'h', ' ']

examView = new ExamView
    model: theExamModel
    task: theTaskView
