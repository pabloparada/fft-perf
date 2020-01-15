local nl = require 'numlua'
local ct = require "create_table"
local lmp = require "luamemprofiler"

lmp.start(arg)

local FREQUENCY = 2048
local FREQUENCY_SCALE = 400

local random = math.random
local sin = math.sin
local format = string.format
local clock = os.clock
local fft_plan = fft.plan
local fft_flag = fft.flag["estimate"]
local matrix_new = matrix.new
local create_table = ct.create_table
local complex = complex

-- generate 2khz sample with sine function within random seed
local function generate(f, s, r)

    -- frequency adjusted when f is null
    local ff = f or FREQUENCY

    -- frequency scale (keep it between -400 and 400)
    local rr = r or FREQUENCY_SCALE

    local v = matrix_new(ff, true)

    -- generated data accumulator
    for i = 1, ff do
        local cp = complex(sin(random()) * rr, true)
        v[i] = cp
    end

    return v
end
-- store execution number
local en = 1

-- main function
local function run(t2, dl)

    -- increment execution number
    en = en + 1

    -- calculate fft for data line (d')
    -- matrix_table.fft(matrix_table, false)
    fft_plan(dl, false, fft_flag)()

    local t3 = clock() - t2

    print(format('algorithm runner -> execution n %d total execution time %.8fms %.8fs\n', en, t3 * 1000, t3))

    return t3
end

-- users can call this script with loop args to never stop
-- independent of iteration counting
local s = #arg > 0 and tonumber(arg[1]) or 0

-- number of iterations (default 10)
local it = s == 0 and 10 or s

-- opposite from node lua is really bad at memory allocation (table creation)
-- (that's what i found during this tests) so we are measuring
-- different tasks in different times, memory allocation is measured isolated
-- from execution time and this 'g' variable will be used as a cache for
-- frequencies
local g = create_table(it, it)

local t0 = clock()

for i = 1, it do
    g[i] = generate()

    local t1 = clock() - t0

    print(format('memory allocation -> execution n %d total execution time %.8fms %.8fs\n', i, t1 * 1000, t1))
end

-- clock that will be used
-- to control execution time
local t2 = clock()

-- run until execution number equals
-- to iteration number
repeat
    run(t2, g[en])
until en >= it

lmp.stop()