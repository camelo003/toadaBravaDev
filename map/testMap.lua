return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.4",
  orientation = "orthogonal",
  renderorder = "left-up",
  width = 20,
  height = 20,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 8,
  nextobjectid = 9,
  properties = {},
  tilesets = {
    {
      name = "tiles_packed",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 23,
      image = "tilesets/testMap.png",
      imagewidth = 369,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 184,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "UL_1",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        128, 128, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 155, 128, 128,
        128, 157, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 127, 128,
        128, 157, 128, 28, 28, 28, 28, 28, 28, 28, 28, 20, 28, 28, 28, 28, 28, 51, 127, 128,
        128, 157, 128, 20, 28, 28, 21, 22, 22, 22, 22, 22, 23, 28, 28, 28, 28, 128, 156, 156,
        128, 157, 128, 28, 28, 28, 44, 28, 28, 28, 28, 28, 46, 28, 28, 51, 28, 128, 127, 128,
        128, 157, 128, 28, 28, 28, 44, 28, 28, 28, 28, 28, 46, 28, 28, 28, 28, 128, 127, 128,
        128, 157, 128, 28, 28, 28, 44, 28, 28, 20, 28, 28, 46, 28, 28, 28, 28, 128, 127, 128,
        128, 157, 128, 28, 28, 28, 44, 28, 28, 28, 28, 28, 46, 28, 28, 28, 28, 128, 127, 128,
        128, 157, 128, 28, 20, 28, 67, 68, 68, 68, 68, 68, 69, 28, 28, 28, 28, 128, 127, 128,
        128, 157, 128, 28, 28, 28, 25, 10, 11, 11, 11, 12, 27, 28, 28, 28, 28, 128, 127, 128,
        128, 157, 51, 28, 28, 28, 48, 33, 34, 34, 34, 35, 50, 28, 20, 28, 28, 128, 127, 128,
        128, 157, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 127, 128,
        128, 157, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 127, 128,
        128, 128, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 128, 128,
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "BL_2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 2, 3, 4, 5, 4, 5, 2, 3, 4, 5, 2, 3, 4, 5, 6, 0, 0,
        0, 0, 24, 0, 0, 171, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78, 79, 79,
        0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 0, 75, 0, 0,
        0, 0, 70, 0, 0, 0, 0, 0, 0, 0, 0, 172, 0, 0, 0, 0, 0, 75, 0, 0,
        0, 0, 24, 0, 149, 0, 0, 173, 174, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0,
        0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0,
        0, 0, 70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 149, 83, 84, 0, 75, 0, 0,
        0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 75, 0, 0,
        0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0,
        79, 79, 80, 0, 0, 171, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 153, 154, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 177, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 3,
      name = "FL_3",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 14, 15, 16, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 37, 38, 39, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59, 60, 61, 62, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 5,
      name = "WALK_caminhos",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 36.5,
          y = 37.5,
          width = 246.5,
          height = 163.5,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.5,
          y = 179.5,
          width = 49.5,
          height = 9.5,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280.5,
          y = 50.5,
          width = 41,
          height = 10.5,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 6,
      name = "BLOCK_bloqueios",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 112.667,
          y = 171.667,
          width = 79.6667,
          height = 17,
          rotation = 0,
          visible = true,
          properties = {
            ["customBool"] = true,
            ["customFIle"] = "map/gameFolder/testMap.png",
            ["customString"] = "eita"
          }
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 118.333,
          y = 96.3333,
          width = 20.3333,
          height = 17.3333,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256.333,
          y = 147.667,
          width = 15,
          height = 13,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 7,
      name = "EVENTS",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 7,
          name = "Left exit",
          type = "teleport",
          shape = "rectangle",
          x = -2.33333,
          y = 176.667,
          width = 8.66667,
          height = 14.6667,
          rotation = 0,
          visible = true,
          properties = {
            ["action"] = "",
            ["activationSwitches"] = "",
            ["cameraX"] = 0,
            ["cameraY"] = 0,
            ["facing"] = "left",
            ["map"] = "",
            ["sendToX"] = 50,
            ["sendToY"] = 50,
            ["specialDrawings"] = "",
            ["trigger"] = "touch"
          }
        },
        {
          id = 8,
          name = "",
          type = "teste",
          shape = "rectangle",
          x = 312.667,
          y = 48.3333,
          width = 10.3333,
          height = 17.6667,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}