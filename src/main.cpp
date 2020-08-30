#include "./configApp/configApp.cpp"
#include "./include/logger.h"
#include <iostream>

int main(int argc, char **argv) {
  std::cout << "Hello, world!\n";
  configApp::load_config_file(argc, argv);
  Logger::GetInstance().sink_info->info("Hello");
}
