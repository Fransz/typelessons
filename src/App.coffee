App = App or {}


App.initialModels = _.map [
    # "asdfg","hjkl;"
    "gh", "fj", "dj", "sl", "a;",

    # "zxcvb","nm,./"
    # "bn", "vm", "c,", "x.", "z/",

    # "qwert","yuiop"
    # "yt", "ur", "ie", "ow", "pq",

    # "12345","67890"
    # "56", "47","38", "29", "10",

    # "asdfg","hjkl;" "zxcvb","nm,./"
    # "ghbn", "fjvm", "dkc,", "slx.", "a;z.",

    # "asdfg","hjkl;" "qwert","yuiop"
    # "ghty", "fjru", "dkie", "lsow", "a;qp",

    # "asdfg","hjkl;" "12345","67890"
    # "gh56", "fj47", "dk38", "sl29", "a;10",

    # "asdfg","hjkl;" "zxcvb","nm,./" "qwert","yuiop"
    # "ghtybn", "fjruvm", "dkeicm", "slwox.", "qpa;z.",

    # "asdfg","hjkl;" "zxcvb","nm,./" "qwert","yuiop" "12345","67890"
    # "azq1hnm6", "sxw2jmu7", "dce3k,i8", "fvr4l.o9", "gbt5;/p0"
], (s) -> s.split('')

# Sample function.
#
# @see snippets/sample/src/sample.coffee
App.sample = (values, distribution, cnt) ->
    if not values.length
        throw new Error "Cannot sample, arrays are unequal sized."
    if values.length isnt distribution.length
        throw new Error "Cannot sample, arrays are unequal sized."
    if _.reduce(distribution, ( (m, v) -> m + v ), 0) isnt 1
        throw new Error "Cannot sample, probabilities do not count up to 1."

    _initialize = (distribution) ->
        ss = []                                             # indices with p < p_gem
        ls = []                                             # indices with p >= p_gem
        p_avg = 1 / distribution.length

        pTable = _.map distribution, () -> undefined        # result tables all entries undefined.
        aTable = _.map distribution, () -> undefined

        ps = _.map distribution, (p) -> p / p_avg           # normalized distribution.

        # init the larger and smaller array
        _.each ps, (p, i) -> if p < 1 then ss.unshift i else ls.unshift i

        while ss.length and ls.length
            s = ss.shift()
            pTable[s] = ps[s]

            l = ls.shift()
            aTable[s] = l
            p_ = (ps[l] + ps[s]) - 1                        # ps[l] - (1 - ps[s])

            ps[l] = p_
            if p_ < 1 then ss.unshift l else ls.unshift l

        while ls.length
            pTable[ls.shift()] = 1

        while ss.length
            pTable[ss.shift()] = 1

        [pTable, aTable]


    _generate = (values, pTable, aTable) ->
        die = Math.floor Math.random() * values.length
        coin = Math.random()
        if coin < pTable[die] then values[die] else values[aTable[die]]

    [pTable, aTable] = _initialize distribution
    _generate(values, pTable, aTable) for [0 ... cnt]

App.theTaskCollectionView = new TaskCollectionView
