#include <stdbool.h>
#include <stdio.h>
#include <SDL2/SDL.h>

int main(int argc, char *argv[]) {
    printf("Hello Spacess\n");
    if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_EVENTS) != 0) {
        fprintf(stderr, "Unable to initialize SDL: %s", SDL_GetError());
        return 1;
    }

    // Create an application window with the following settings:
    SDL_Window *window = SDL_CreateWindow("An SDL2 window", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1024, 512, 0);
    // Check that the window was successfully created
    if (window == NULL) {
        // In the case that the window could not be made...
        fprintf(stderr, "Could not create window: %s\n", SDL_GetError());
        return 1;
    }

    bool running = true;
    while(running)
    {
        SDL_Event event;
        while(SDL_PollEvent(&event) > 0)
        {
            switch(event.type)
            {
                case SDL_QUIT:
                    running = false;
                    break;
            }
        }
    }

    // Close and destroy the window
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}