theExamModel = null

$(
    () ->
        theExamModel = new ExamModel {letters: ['g', 'h']}

        examKeyboardView = new ExamKeyboardView
            model: theExamModel
            el: "#exam #keyboard"
)
