#include <iostream>
#include <fstream>
#include <string>

#define FILENAME "/home/jeremy/bin/.temp/lol_count"
#define HA "HA"


int read_count(const std::string filename) {
    std::ifstream file(filename);
    int count;
    file >> count;
    file.close();
    return count;
}

void write_count(const std::string filename, const long count) {
    std::ofstream file(filename);
    file << std::to_string(count);
    file.close();
}

int main() {
    std::string lol_str = HA;
    long lol_count = read_count(FILENAME);
    write_count(FILENAME, ++lol_count);
    for (long i = 0; i < lol_count; i++) {
        lol_str += HA;
    }
    lol_str += "\n";
    std::cout << lol_str;
    return 0;
}