require('luacov')
local sort = table.sort
local floor = math.floor
local random = math.random
local minheap = require('minheap')
local testcase = require('testcase')

function testcase.new()
    -- test that returns instance of minheap
    local h = assert(minheap.new())
    assert.equal(#h.arr, 0)
    assert.equal(h.len, 0)
end

function testcase.push()
    local h = assert(minheap.new())
    local data = {
        {
            pri = 39,
            val = 'foo',
        },
        {
            pri = 31,
            val = 'bar',
        },
        {
            pri = 4,
            val = 'baz',
        },
        {
            pri = 131,
            val = 'qux',
        },
        {
            pri = 31,
            val = 'quux',
        },
    }

    -- test that can push values
    for i, v in ipairs(data) do
        local node = h:push(v.pri, v.val)
        assert.equal(node.pri, v.pri)
        assert.equal(node.val, v.val)
        assert.equal(h.len, i)
    end

    -- test that throws an error with invalid priority
    local err = assert.throws(function()
        h:push('foo', 'bar')
    end)
    assert.match(err, ' must be number')
end

function testcase.pop()
    local h = assert(minheap.new())
    local data = {
        {
            pri = 39,
            val = 'foo',
        },
        {
            pri = 31,
            val = 'bar',
        },
        {
            pri = 4,
            val = 'baz',
        },
        {
            pri = 131,
            val = 'qux',
        },
        {
            pri = 31,
            val = 'quux',
        },
    }
    for i, v in ipairs(data) do
        local node = h:push(v.pri, v.val)
        assert.equal(node.pri, v.pri)
        assert.equal(node.val, v.val)
        assert.equal(h.len, i)
    end

    -- test that can pop values in order of priority
    for i = #data, 1, -1 do
        h:pop()
        assert.equal(h.len, i - 1)
    end
    assert.equal(#h.arr, 0)
    assert.equal(h.len, 0)
end

function testcase.peek()
    local h = assert(minheap.new())
    for _, v in ipairs({
        {
            pri = 59,
            val = 'foo',
        },
        {
            pri = 31,
            val = 'bar',
        },
        {
            pri = 4,
            val = 'baz',
        },
        {
            pri = 131,
            val = 'qux',
        },
        {
            pri = 11,
            val = 'quux',
        },
    }) do
        h:push(v.pri, v.val)
    end

    -- test that the highest priority value exists at the top
    for _, v in ipairs({
        {
            pri = 4,
            val = 'baz',
        },
        {
            pri = 11,
            val = 'quux',
        },
        {
            pri = 31,
            val = 'bar',
        },
        {
            pri = 59,
            val = 'foo',
        },
        {
            pri = 131,
            val = 'qux',
        },
    }) do
        local pnode = h:peek()
        assert.equal(pnode.pri, v.pri)
        assert.equal(pnode.val, v.val)

        local node = h:pop()
        assert.equal(node, pnode)
    end
end

function testcase.del()
    math.randomseed(os.time())
    local h = assert(minheap.new())
    local nodes = {}
    for i = 1, 1000 do
        nodes[i] = h:push(i, i)
    end
    -- shuffle
    for i = #nodes, 1, -1 do
        local j = floor(random(i))
        nodes[i], nodes[j] = nodes[j], nodes[i] -- swap
    end

    -- test that delete node
    for i, v in ipairs(nodes) do
        assert.equal(h:del(v.idx), v)
        if i == 500 then
            break
        end
    end
    -- remove delted nodes
    do
        local remains = {}
        for i = 501, #nodes do
            remains[#remains + 1] = nodes[i]
        end
        nodes = remains
        sort(nodes, function(a, b)
            return a.pri < b.pri
        end)
    end

    -- test that an out-of-range index cannot delete a node
    assert.is_nil(h:del(-1))

    -- test that can pop values in order of priority
    for _, v in ipairs(nodes) do
        local node = h:peek()
        assert.equal(node, v)
        h:pop()
    end
    assert.equal(#h.arr, 0)
    assert.equal(h.len, 0)
end

