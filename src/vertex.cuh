#pragma once
#include <vector>
#include <fstream>
#include <iostream>

struct vertex
{
  float x, y, z, w;
  vertex(float x, float y, float z, float w) : x(x), y(y), z(z), w(w) {}
  vertex() : x(0.f), y(0.f), z(0.f), w(0.f) {}
};

std::ostream& operator<<(std::ostream& ostream, const vertex& vert)
{
  ostream << "(" << vert.x << ", " << vert.y << ", " << vert.z << ", " << vert.w << ")\n";
  return ostream;
}
float* load_into_gpu(std::vector<vertex>& verts)
{
  // Do the cuda malloc here and stuffs, put cuda.h, launch_time_parameters.h at the top
}
std::vector<vertex> load_from_file(std::string& filePath)
{
  // 1st. Load all of the bytes from the file. Bonus points if you can throw an exception if an invalid file is passed in (num bytes doesn't match num verts, or file doesnt exist)
  char* rawBytes = nullptr;

  std::ifstream load_file(filePath, std::ios::binary | std::ios::in | std::ios::ate);
  unsigned int numVerts;
  if(load_file.is_open())
  {
    auto size = load_file.tellg();
    rawBytes = new char[size]; 
    load_file.seekg(0, std::ios::beg);
    load_file.read(rawBytes, size);
    load_file.close();

    numVerts = *reinterpret_cast<unsigned int*>(rawBytes);
    if(numVerts*sizeof(float) *3  != ((size_t)size - sizeof(unsigned int)))
    {
      throw std::runtime_error("Invalid file, numVerts != size of file");
    }

  } else {
    throw std::runtime_error("File not found");
  }

  // 3rd. offset raw bytes by one unsigned int and reinterpret as float*
  auto file_verts = reinterpret_cast<float*>(rawBytes + sizeof(unsigned int));

  // Finally, read off each vertex and store into vector, then return vector
  std::vector<vertex> verts;
  for (auto i = 0; i < numVerts; i++)
  {
    verts.emplace_back(file_verts[i*3], file_verts[i*3 +1], file_verts[i*3 +2], 1.0f);
  }

  return verts;
}