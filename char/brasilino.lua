return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.4",
  orientation = "orthogonal",
  renderorder = "left-up",
  width = 3,
  height = 4,
  tilewidth = 75,
  tileheight = 70,
  nextlayerid = 3,
  nextobjectid = 2,
  properties = {},
  tilesets = {
    {
      name = "brasilino",
      firstgid = 1,
      tilewidth = 75,
      tileheight = 70,
      spacing = 0,
      margin = 0,
      columns = 3,
      image = "char/brasilino.png",
      imagewidth = 225,
      imageheight = 280,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 75,
        height = 70
      },
      properties = {},
      terrains = {},
      tilecount = 12,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "ANIM",
      x = 0,
      y = 0,
      width = 3,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["ANIM"] = "return {\n  walkUp = {row = 1, order = {1,2,3,2}},\n  walkDown = {row = 2, order = {1,2,3,2}},\n  walkLeft = {row = 3, order = {1,2,3,2}},\n  walkRight = {row = 4, order = {1,2,3,2}},\n}"
      },
      encoding = "lua",
      data = {
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
        10, 11, 12
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "COLLISION",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "collision",
          shape = "rectangle",
          x = 11.25,
          y = 52.25,
          width = 49,
          height = 19.5,
          rotation = 0,
          visible = true,
          properties = {
            ["collisionRows"] = "{1,2,3,4}"
          }
        }
      }
    }
  }
}
