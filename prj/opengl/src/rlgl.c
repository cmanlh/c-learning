// #include <math.h>

#include "raylib.h"
#include "rlgl.h"
#include "raymath.h"

static Vector2 rotate(Vector2 point, Vector2 center, float radians)
{

    Vector2 newPoint = Vector2Add(Vector2Rotate(Vector2Subtract(point, center), radians), center);
    return newPoint;
}

int main(int argc, char const *argv[])
{
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib opengl");

    SetTargetFPS(60);

    Vector2 center = (Vector2){120, 200};

    Vector2 center2 = (Vector2){512, 200};
    // float radius = 100;
    Color color = BLACK;
    float radiusH = 100.0f;
    float radiusV = 128.0f;
    while (!WindowShouldClose())
    {
        ClearBackground(RAYWHITE);

        BeginDrawing();

        rlBegin(RL_LINES);
        Vector2 startPoint = rotate((Vector2){center.x + radiusH, center.y}, center, PI / 6.0f);
        for (int i = 0; i < 360; i += 10)
        {
            rlColor4ub(color.r, color.g, color.b, color.a);

            rlVertex2f(startPoint.x, startPoint.y);

            Vector2 endPoint = rotate((Vector2){center.x + cosf(DEG2RAD * (i + 10)) * radiusH, center.y + sinf(DEG2RAD * (i + 10)) * radiusV}, center, PI / 6.0f);
            rlVertex2f(endPoint.x, endPoint.y);

            startPoint = endPoint;
        }
        rlEnd();

        rlBegin(RL_TRIANGLES);
        startPoint = rotate((Vector2){center2.x + radiusH, center2.y}, center2, PI / 6.0f);
        for (int i = 0; i < 360; i += 10)
        {
            rlColor4ub(color.r, color.g, color.b, color.a);
            rlVertex2f(center2.x, center2.y);

            Vector2 endPoint = rotate((Vector2){center2.x + cosf(DEG2RAD * (i + 10)) * radiusH, center2.y + sinf(DEG2RAD * (i + 10)) * radiusV}, center2, PI / 6.0f);
            rlVertex2f(endPoint.x, endPoint.y);

            rlVertex2f(startPoint.x, startPoint.y);

            startPoint = endPoint;
        }
        rlEnd();

        EndDrawing();
    }
}
