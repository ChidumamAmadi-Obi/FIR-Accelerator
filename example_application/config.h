#pragma once

#define FILTER_TYPE 0

typedef struct{
    const float lpf[8] = {0.0310, 0.0810, 0.1480, 0.1880, 0.1880, 0.1480, 0.0810, 0.0310}; // low pass
    const float hpf[8] = {-0.0220, -0.0570, 0.0730, 0.2570, 0.2570, 0.0730, -0.0570, -0.0220}; // high pass
    const float dif[8] =  {-0.0250, -0.0500, -0.1000, 0.0000, 0.1000, 0.0500, 0.0250, 0.0000}; // differentiator (detectes rapid changes/ outliers)
}FilterTypes;