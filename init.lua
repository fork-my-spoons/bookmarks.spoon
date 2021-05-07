local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Chrome Bookmarks"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://fork-my-spoons.github.io/spoons/bookmarks/"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.iconPath = hs.spoons.resourcePath("icons")
obj.timer = nil
obj.refreshTimer = nil
obj.notificationType = nil
obj.menu = {}

local function build(menu, n)
    for _, node in ipairs(n.children) do
        if node.type == 'url' then
            table.insert(menu, {
                image = hs.image.imageFromPath(obj.iconPath .. '/external-link.png'):setSize({w=16,h=16}):template(true),
                title = node.name,
                fn = function() os.execute('open ' .. node.url) end
            })
        elseif node.type == 'folder' then
            table.insert(menu, {
                image = hs.image.imageFromPath(obj.iconPath .. '/folder.png'):setSize({w=16,h=16}):template(true),
                title = node.name,
                menu = build({}, node)
            }) 
        end
    end

    return menu
end

function obj:buildMenu()
    local b = hs.json.read(os.getenv("HOME") .. '/Library/Application Support/Google/Chrome/Default/Bookmarks')
    local menu = {}

    return build(menu, b.roots.bookmark_bar)
end


function obj:aaa()
    return obj.menu
end

function obj:init()
    self.indicator = hs.menubar.new()

    self.indicator:setIcon(hs.image.imageFromPath(self.iconPath .. '/bookmark.png'):setSize({w=16,h=16}), true)

    self.indicator:setMenu(self.buildMenu)
end

function obj:setup(args)
    self.notificationType = args.notificationType or 'alert'
end

return obj