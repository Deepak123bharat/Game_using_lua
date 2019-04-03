function love.load()
    love.graphics.setNewFont(30)

    gx = 4   --gx used for grid X Count
    gy = 4   --gy used for grid Y Count
 
    function gi(x, y)   --gi used to get Initial Value
        return x + ((y - 1) * gx)
    end

    function m(d)  -- d stands for direction    &   m used for move
        local ex   --ex used for empty X
        local ey   --ey used for empty Y

        for y = 1, gy do
            for x = 1, gx do
                if g[y][x] == gx * gy then  -- g used for grid
                    ex = x
                    ey = y
                end
            end
        end

        local ney = ey  --ney used for new Empty Y
        local nex = ex   --nex used for new Empty x

        if d == 'down' then
            ney = ey -  1
        elseif d == 'up' then
            ney = ey +  1
        elseif d == 'right' then
            nex = ex -  1
        elseif d == 'left' then
            nex = ex +  1
        end

        if g[ney] and g[ney][nex] then
            g[ney][nex], g[ey][ex] =
            g[ey][ex], g[ney][nex]
        end
    end

    function ic()   -- ic to check completed or not 
        for y = 1, gy do
            for x = 1, gx do
                if g[y][x] ~= gi(x, y) then
                    return false
                end
            end
        end
        return true
    end

    function reset()
        g = {}
        for y = 1, gy do
            g[y] = {}
            for x = 1, gx do
                g[y][x] = gi(x, y)
            end
        end

        repeat
            for mn = 1, 1000 do  --used for move Number
                local roll = love.math.random(4)
                if roll == 1 then
                    m('down')
                elseif roll == 2 then
                    m('up')
                elseif roll == 3 then
                    m('right')
                elseif roll == 4 then
                    m('left')
                end
            end

            for mn = 1, gx - 1 do
                m('left')
            end

            for mn = 1, gy - 1 do
                m('up')
            end
        until not ic()
    end

    reset()
end

function love.draw()
    for y = 1, gy do
        for x = 1, gx do
            if g[y][x] ~= gx * gy then
                local ps = 100   -- ps used for piece Size
                local pds = ps - 1  -- pds used for piece Draw Size
                love.graphics.setColor(0.5, 0.5, 1)
                love.graphics.rectangle(
                    'fill',
                    (x - 1) * ps,
                    (y - 1) * ps,
                    pds,
                    pds
                )
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(
                    g[y][x],
                    (x - 1) * ps,
                    (y - 1) * ps
                )
            end
        end
    end
end

function love.keypressed(key)
    if key == 'down' then
        m('down')
    elseif key == 'up' then
        m('up')
    elseif key == 'right' then
        m('right')
    elseif key == 'left' then
        m('left')
    end

    if ic() then
        reset()
    end
end
