
#include "./includes/rendererV1.hpp"
#include <lua.hpp>


// TODO: make the background retangles relative to the screen size, also with spawning


class Subhunt: public groover::Renderer {

    private:

        void BackgroundDraw() {
            for(int i=150; i<700; i+=100) {
                this->SetColor(50 , (int)266 - i / 3, 200);
                this->DrawRec(groover::point{0.0f, (float)i}, groover::point{(float)winWidth, (float)i+100});
            }
        }

        void IttrRects() {
            // we have a table of tables not rn so ignore

            lua_pushvalue(L, -1);
            lua_pushnil(L);

            float points[4];
            int counter = 0;

            this->SetColor(83, 83, 83);
            while(lua_next(L, -2) != 0) {

                int key_v = lua_tonumber(L, -2);
                float value = lua_tonumber(L, -1);

                points[counter] = value;
                counter += 1;
                if (counter == 4) {

                    this->DrawRec(groover::point{ points[0], points[1] }, groover::point{ points[2], points[3] } );
                    counter = 0;

                }
                lua_pop(L, 1);
            }
            lua_pop(L, 1);
            // Stack is now the same as it was on entry to this function
        }

        void IttrTris() {

            lua_pushvalue(L, -1);
            lua_pushnil(L);

            float points[6];
            int counter = 0;

            while(lua_next(L, -2) != 0) {

                int key_v = lua_tonumber(L, -2);
                float value = lua_tonumber(L, -1);

                points[counter] = value;
                counter += 1;
                if (counter == 6) {
                    this->DrawTriangle( groover::point{ points[0], points[1] },
                                        groover::point{ points[2], points[3] },
                                        groover::point{ points[4], points[5] } );

                    counter = 0;
                }
                lua_pop(L, 1);
            }
            lua_pop(L, 1);
            // Stack is now the same as it was on entry to this function
        }


    public:

        int key_send = -2;

        lua_State* L;

        bool Startup() override {

            L = luaL_newstate();
            luaL_openlibs(L);
            // we have all lua libraries
            luaL_dofile(L, "./lua/subhunt.lua");

            // white background
            this->SetBackgroundColor(255,255,255);
            return true;
        }

        bool Update(float deltaTime) override {
            this->BackgroundDraw();

            lua_pushnumber(L, deltaTime);
            lua_setglobal(L, "delta_time");

            lua_pushnumber(L, winWidth);
            lua_setglobal(L, "screen_width");

            lua_pushnumber(L, winHeight);
            lua_setglobal(L, "screen_height");

            lua_getglobal(L, "main");
            lua_pushinteger(L, key_send); // has to be after main lets lua know what key we are pressing
            lua_pcall(L, 1, 0, 0);
            
            // calling main function and setting delta_time, screen_width, screen_height

            lua_getglobal(L, "get_rects"); // maybe need to function then
            lua_call(L, 0, 1);
            this->IttrRects();

            lua_getglobal(L, "get_tris");
            lua_call(L, 0, 1);
            this->IttrTris();

            lua_pop(L, lua_gettop(L)); // clean stack if extra stuff

            return true;
        }

};

Subhunt renderer;

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {

            if(key == GLFW_KEY_LEFT && (action == GLFW_PRESS | action == GLFW_REPEAT)) {
                renderer.key_send = 0;
            }
            else if(key == GLFW_KEY_RIGHT && (action == GLFW_PRESS | action ==  GLFW_REPEAT)) {
                renderer.key_send = 1;
            }
            else if(key == GLFW_KEY_SPACE && action == GLFW_PRESS) {
                renderer.key_send = 2;
            }
            else { renderer.key_send = -1; }
 }

int main() {

    renderer.CreateWin("Subhunt", 1200, 800, false);
    glfwSetKeyCallback(renderer.window, key_callback);
    renderer.Run();

    return 0;
}

