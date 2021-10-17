changequote([[, ]])dnl
define(_long_comment,)dnl
_long_comment([[
void 
example_function (int x, int y)
{
  int x = sqrt (100);
  for (int i = 0; i < x; i++)
    {
      example_function (x * y, y + 2);
    }
  do
    {
      another_example_function ();
    }
  while ()
}]])dnl
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#define MAX_ROWS 16
#define MAX_COLS 16

#define SUCCESS 0
#define ERROR 1

#define TEXTURE_WIDTH 1024
#define TEXTURE_HEIGHT 512
#define MAX_TEXTURES_COUNT 64

struct Camera
{
  double position[2];
};


struct Cell
{
  int position[2];
};

struct Room
{
  int size[2];
  struct Cell cells[MAX_ROWS][MAX_COLS];
};

struct GameManager
{
  bool running;
  SDL_Window *window;
  SDL_Renderer *renderer;
  SDL_Texture *texture;
  struct Camera camera;
  struct Room room;
  SDL_Texture *textures[MAX_TEXTURES_COUNT];
  int textures_count;
};

struct GameManager manager;

void
draw_room (struct Room *room, struct Camera *camera, SDL_Renderer *renderer)
{

}

int
load_texture (char *path)
{
  assert (manager.renderer != NULL);
  assert (manager.textures_count < MAX_TEXTURES_COUNT);
  SDL_Surface *surface;
  surface = IMG_Load (path);
  if (surface = NULL) 
    {
      fprintf (stderr, "IMG_Load: %s\n", IMG_GetError ());
      return ERROR;
    }
  manager.textures[manager.textures_count] = SDL_CreateTextureFromSurface (manager.renderer, surface);
  if (manager.textures[manager.textures_count] == NULL)
  {
    fprintf (stderr, "Could not load texture(%s): %s\n",path, SDL_GetError ());
    return ERROR;
  }
  manager.textures_count++;
  SDL_FreeSurface (surface);
  return SUCCESS;
}

int
load_textures ()
{
  manager.textures_count = 0;
  if (load_texture("resources/sprites/bg0x0.png") == ERROR)
   {
     return ERROR;
   }
  return SUCCESS;
}

int
initialize_room (struct Room *room, int width, int height)
{
  room->size[0] = width;
  room->size[1] = height;
  for (int y = 0; y < height; y++)
   {
     for (int x =0; x < width; x++)
      {
        struct Cell *cell = &room->cells[y][x];
        cell->position[0] = x;
        cell->position[1] = y;
      }
   }
   return SUCCESS;
}

int
initialize_camera (struct Camera *camera, double x, double y)
{
  camera->position[0] = x;
  camera->position[1] = y;
  return SUCCESS;
}

int
initialize()
{
  if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_EVENTS) != 0)
    {
      fprintf (stderr, "Unable to initialize SDL: %s", SDL_GetError ());
      return ERROR;
    }
  
  int flags = IMG_INIT_PNG;
  int initted = IMG_Init (flags);
  if ((initted & flags) != flags)
    {
      fprintf (stderr, "IMG_Init: Failed to init required image formats support!\n");
      fprintf (stderr, "IMG_Init: %s\n", IMG_GetError ());
      return ERROR;
    }
  manager.window = SDL_CreateWindow("Spacess", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1024, 512, SDL_WINDOW_HIDDEN);
  if (manager.window == NULL)
    {
      fprintf (stderr, "Could not create window: %s\n", SDL_GetError ());
      return ERROR;
    }
  manager.renderer = SDL_CreateRenderer (manager.window, -1, 0);
  if (manager.renderer == NULL)
    {
      fprintf (stderr, "Could not create renderer: %s\n", SDL_GetError ());
      return ERROR;
    }  
  manager.texture = SDL_CreateTexture (manager.renderer, SDL_PIXELFORMAT_UNKNOWN, SDL_TEXTUREACCESS_TARGET, TEXTURE_WIDTH, TEXTURE_HEIGHT);
  if (manager.texture == NULL)
    {
      fprintf (stderr, "Could not create texture: %s\n", SDL_GetError ());
      return ERROR;
    }
  if (initialize_room (&manager.room, 8, 8) == ERROR)
    {
      return ERROR;
    }
  if (initialize_camera (&manager.camera, 0., 0.) == ERROR)
    {
      return ERROR;
    }
  if (load_textures () == ERROR)
    {
      return ERROR;
    }
  return SUCCESS;
}

int
start()
{
  SDL_ShowWindow (manager.window);
  manager.running = true;
  while (manager.running)
    {
      
      SDL_SetRenderTarget (manager.renderer, manager.texture);
      SDL_SetRenderDrawColor(manager.renderer, 64, 0, 64, 255);
      SDL_RenderClear (manager.renderer);
      draw_room(&manager.room, &manager.camera, manager.renderer);
      SDL_SetRenderTarget (manager.renderer, NULL);
      SDL_SetRenderDrawColor(manager.renderer, 0, 0, 0, 255);
      SDL_RenderClear (manager.renderer);
      SDL_RenderCopy (manager.renderer, manager.texture, NULL, NULL);
      SDL_RenderPresent (manager.renderer);

      SDL_Event event;
      while (SDL_PollEvent (&event) > 0)
        {
          switch (event.type)
            {
            case SDL_QUIT:
              manager.running = false;
              break;
            }
        }
    }
  return SUCCESS;
}

void
free_textures ()
{
  for (int i = 0; i < manager.textures_count; i++)
    {
      SDL_DestroyTexture (manager.textures[i]);
    }
}

void
quit ()
{
  free_textures ();
  SDL_DestroyTexture (manager.texture);
  SDL_DestroyRenderer (manager.renderer);
  SDL_DestroyWindow (manager.window);
  IMG_Quit ();
  SDL_Quit ();
}

int
main(int argc, char *argv[])
{
  int i = initialize ();
  if (i == ERROR)
    {
      quit ();
      return i;
    }
  i = start ();
  quit ();
  return i;
}