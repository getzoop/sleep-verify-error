#include <thread>

namespace my::time {

std::tuple<std::chrono::seconds, size_t> 
  SplitTime(const size_t seconds) {
    return { std::chrono::seconds(seconds/10), 10 };
  }

void MySleep() {
  auto [ interval, multiplier ] = SplitTime(10);

  for (size_t i = 0; i < multiplier; ++i)
    std::this_thread::sleep_for(interval);

}

};
