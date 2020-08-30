#include <chrono>
#include <filesystem>
#include <iostream>
#include <thread>

#include "./configApp.h"

namespace fs = std::filesystem;

bool configApp::load_config_file(int argc, char **argv) {
  std::this_thread::sleep_for(std::chrono::seconds(1));
  auto dir = fs::weakly_canonical(fs::path(argv[0])).parent_path();
  std::cout << "Current path is " << dir.c_str() << '\n';
  return 0;
}
