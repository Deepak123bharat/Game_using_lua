function love.load()
    gX = 40            -- gX used for grid X count
    gY = 27    -- gY used for grid Y count 

    function mf()    -- mf used for move Food
        local pfp = {}      --pfp used for possible Food Positions 

        for fx = 1, gX do     --fx used for food X
            for fy = 1, gY do --fy used for food Y
                local possible = true

                for si, seg in ipairs(ss) do --si used for segment Index, seg used for segment, ss used for snake Segments
                    if fx == seg.x and fy == seg.y then
                        possible = false
                    end
                end

                if possible then
                    table.insert(pfp, {x = fx, y = fy})
                end
            end
        end

        fp = pfp[love.math.random(1, #pfp)] --fp used for food Position
    end

    function reset()
        ss = {
            {x = 3, y = 1},
            {x = 2, y = 1},
            {x = 1, y = 1},
        }
        dq = {'right'}  --dq used for direction queue
        snakeAlive = true
        timer = 0
        mf()
    end

    reset()
end

function love.update(dt)
    timer = timer + dt

    if snakeAlive then
        local timerLimit = 0.25
        if timer >= timerLimit then
            timer = timer - timerLimit

            if #dq > 1 then
                table.remove(dq, 1)
            end

            local nxp = ss[1].x --nxp used for next X Position
            local nyp = ss[1].y --nyp used for next Y Position

            if dq[1] == 'right' then
                nxp = nxp + 1
                if nxp > gX then
                    nxp = 1
                end
            elseif dq[1] == 'left' then
                nxp = nxp - 1
                if nxp < 1 then
                    nxp = gX
                end
            elseif dq[1] == 'down' then
                nyp = nyp + 1
                if nyp > gY then
                    nyp = 1
                end
            elseif dq[1] == 'up' then
                nyp = nyp - 1
                if nyp < 1 then
                    nyp = gY
                end
            end

            local canMove = true

            for si, seg in ipairs(ss) do
                if si ~= #ss
                and nxp == seg.x 
                and nyp == seg.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(ss, 1, {x = nxp, y = nyp})

                if ss[1].x == fp.x
                and ss[1].y == fp.y then
                    mf()
                else
                    table.remove(ss)
                end
            else
                snakeAlive = false
            end
        end
    elseif timer >= 2 then
        reset()
    end
end

function love.draw()
    local cellSize = 15

    love.graphics.setColor(0.28, 0, 0, 0.28)
    love.graphics.rectangle(
        'fill',
        0,
        0,
        gX * cellSize,
        gY * cellSize
    )

    local function drawCell(x, y)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1
        )
    end

    for si, seg in ipairs(ss) do
        if snakeAlive then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        drawCell(seg.x, seg.y)
    end

    love.graphics.setColor(1, 0, 1)
    drawCell(fp.x, fp.y)
end

function love.keypressed(key)
    if key == 'right'
    and dq[#dq] ~= 'right'
    and dq[#dq] ~= 'left' then
        table.insert(dq, 'right')

    elseif key == 'left'
    and dq[#dq] ~= 'left'
    and dq[#dq] ~= 'right' then
        table.insert(dq, 'left')

    elseif key == 'up'
    and dq[#dq] ~= 'up'
    and dq[#dq] ~= 'down' then
        table.insert(dq, 'up')

    elseif key == 'down'
    and dq[#dq] ~= 'down'
    and dq[#dq] ~= 'up' then
        table.insert(dq, 'down')
    end
end
