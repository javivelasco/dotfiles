local prefix = "ctrl+s"

local function leader(key)
  return prefix .. ">" .. key
end

-- The prefix starts a sequence, so it no longer reaches the terminal on its
-- own. Press it twice, or follow it with `a`, to send it through.
rex.bind(leader(prefix), "pane.send_key", { key = prefix })
rex.bind(leader("a"), "pane.send_key", { key = prefix })

-- ctrl+l alone moves focus right (see below), so prefix + ctrl+l clears the
-- screen. The form feed is written straight to the terminal: sending the key
-- with pane.send_key would be caught by the ctrl+l binding again.
rex.bind(leader("ctrl+l"), function()
  rex.block.call("com.superlogical.terminal", "write", { data = "\12" })
  return true
end)

rex.bind(leader("r"), "client.config.reload")

-- Sessions
rex.bind(leader("t"), "session.switch")
rex.bind(leader("shift+4"), "session.rename")

-- Tabs
rex.bind(leader("c"), "client.tab.new")
rex.bind(leader("n"), "client.tab.next")
rex.bind(leader("p"), "client.tab.previous")
rex.bind(leader(","), "client.tab.rename")
rex.bind(leader("shift+7"), "client.tab.close")
for index = 1, 9 do
  rex.bind(leader(tostring(index)), "client.tab.goto", { index = index })
end
rex.bind("ctrl+shift+left", "client.tab.move.backward")
rex.bind("ctrl+shift+right", "client.tab.move.forward")

-- Panes, focus and resize
rex.bind(leader("v"), "pane.split", { direction = "right" })
rex.bind(leader("s"), "pane.split", { direction = "down" })

rex.bind(leader("h"), "pane.focus.left")
rex.bind(leader("j"), "pane.focus.down")
rex.bind(leader("k"), "pane.focus.up")
rex.bind(leader("l"), "pane.focus.right")

rex.bind(leader("z"), "pane.zoom")
rex.bind(leader("x"), "pane.close")
rex.bind(leader("o"), "pane.focus_next")
rex.bind(leader("shift+1"), "pane.move_to_new_tab")

-- ctrl+h/j/k/l move between panes without the prefix, like vim-tmux-navigator.
-- While vim is in the foreground the key is left unhandled so it reaches vim,
-- which moves between its own splits.
local editors = { nvim = true, vim = true }

local function navigate(direction)
  return function(ctx)
    local process = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
    if process and process.foreground and editors[process.foreground.name] then
      return false
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end
end

-- Movements
rex.bind("ctrl+h", navigate("left"))
rex.bind("ctrl+j", navigate("down"))
rex.bind("ctrl+k", navigate("up"))
rex.bind("ctrl+l", navigate("right"))

-- Resizing
rex.bind(leader("-"), "pane.resize", { direction = "down", amount = 1 })
rex.bind(leader("shift+="), "pane.resize", { direction = "up", amount = 1 })
rex.bind(leader("shift+,"), "pane.resize", { direction = "left", amount = 1 })
rex.bind(leader("shift+."), "pane.resize", { direction = "right", amount = 1 })
