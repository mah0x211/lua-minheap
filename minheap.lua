--
-- Copyright (C) 2017 Masatoshi Teruya
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- lib/minheap.lua
-- lua-minheap
--
-- Created by Masatoshi Teruya on 17/03/01.
--
--- modules
local assert = assert
local type = type
local floor = math.floor

--- @class MinHeap
local MinHeap = {}

--- isEmpty
--- @return boolean ok
function MinHeap:isEmpty()
    return self.len == 0
end

--- peek
--- @return table? node
function MinHeap:peek()
    return self.arr[1]
end

--- heapup
--- @param arr table
--- @param i integer
local function heapup(arr, i)
    local j = floor(i / 2)

    while i > 1 and arr[i].pri < arr[j].pri do
        arr[i].idx, arr[j].idx = arr[j].idx, arr[i].idx
        arr[i], arr[j] = arr[j], arr[i]
        i = j
        j = floor(j / 2)
    end
end

--- push
--- @param pri integer
--- @param val any
--- @return table node
function MinHeap:push(pri, val)
    assert(type(pri) == 'number', 'pri must be number')
    local tail = self.len + 1
    local node = {
        pri = pri,
        val = val,
        idx = tail,
    }
    local arr = self.arr

    -- add the node to the end
    arr[tail] = node
    self.len = tail
    heapup(arr, tail)

    return node
end

--- pop
--- @return table node
function MinHeap:pop()
    return self:del(1)
end

--- heapdown
---@param arr table
---@param len integer
---@param idx integer
---@return boolean
local function heapdown(arr, len, idx)
    local i = idx
    local j = floor(i * 2)

    while j < len do
        local right = j + 1
        if right < len and arr[right].pri < arr[j].pri then
            j = right
        end

        if arr[i].pri <= arr[j].pri then
            break
        end

        arr[i].idx, arr[j].idx = arr[j].idx, arr[i].idx
        arr[i], arr[j] = arr[j], arr[i]
        i = j
        j = floor(j * 2)
    end

    return i > idx
end

--- del
--- @param idx integer
--- @return table node
function MinHeap:del(idx)
    assert(type(idx) == 'number', 'i must be number')
    local arr = self.arr
    local node = arr[idx]

    -- out of range
    if not node then
        return nil
    end

    local len = self.len
    self.len = len - 1

    -- delete tail
    if idx == len then
        arr[idx] = nil
        return node
    end

    -- move the last node to the idx
    arr[idx] = arr[len]
    arr[idx].idx = idx
    arr[len] = nil
    if not heapdown(arr, len, idx) then
        heapup(arr, idx)
    end

    return node
end

--- new
--- @return MinHeap
local function new()
    return setmetatable({
        arr = {},
        len = 0,
    }, {
        __index = MinHeap,
    })
end

return {
    new = new,
}

