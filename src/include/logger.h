#ifndef CONFIG_APP_LOGGER
#define CONFIG_APP_LOGGER

#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>
#include <string>

class Logger {
public:
  static Logger &GetInstance() {
    static Logger instance;
    return instance;
  }

  std::shared_ptr<spdlog::logger> sink_info, sink_error, sink_warn, sink_debug,
      sink_trace;

  Logger() {
    // create color multi threaded logger
    sink_info = spdlog::stderr_color_mt("info");
    sink_info->set_level(spdlog::level::info);

    sink_error = spdlog::stderr_color_mt("error");
    sink_error->set_level(spdlog::level::err);

    sink_warn = spdlog::stderr_color_mt("warn");
    sink_warn->set_level(spdlog::level::warn);

    sink_debug = spdlog::stderr_color_mt("debug");
    sink_debug->set_level(spdlog::level::debug);

    sink_trace = spdlog::stderr_color_mt("trace");
    sink_trace->set_level(spdlog::level::trace);
  }
};

#endif
