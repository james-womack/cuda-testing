#include <iostream>
#include <fstream>
#include <vector>
#include "vertex.cuh"

int main()
{
  std::ifstream vertsFile("verts.bin", std::ios::binary | std::ios::in | std::ios::ate);

  char* rawBytes = nullptr;
  if (vertsFile.is_open())
  {
    auto end = vertsFile.tellg();
    rawBytes = new char[end];
    vertsFile.seekg(0, std::ios::beg);
    vertsFile.read(rawBytes, end);
    vertsFile.close();

    std::cout << "Length: " << end << std::endl;
  } else
  {
    std::cerr << "Cannot open verts file." << std::endl;
    return -1;
  }

  auto numVerts = *reinterpret_cast<unsigned int*>(rawBytes);
  std::cout << "Number of vertices: " << numVerts << "\n";

  auto floatsPtr = reinterpret_cast<float*>(rawBytes + sizeof(unsigned int));
  std::vector<vertex> vertices;
  for (int i = 0; i < numVerts; ++i)
  {
    vertices.emplace_back(floatsPtr[i*3], floatsPtr[i*3 + 1], floatsPtr[i*3 + 2], 1.0f);
  }

  for (auto vert : vertices)
  {
    std::cout << vert;
  }
  return 0;
}