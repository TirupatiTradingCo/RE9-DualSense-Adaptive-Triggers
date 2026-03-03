#include <iostream>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <string>
#include <thread>
#include <chrono>
#include <windows.h>
#include <fstream>
#include <shellapi.h>

#pragma comment(lib, "ws2_32.lib")

#define DSX_UDP_PORT 26780
#define BUFFER_SIZE 1024

class DSXUDPClient {
private:
    SOCKET sock;
    sockaddr_in serverAddr;
    bool running;
    std::thread listenThread;

    // Current controller state
    int currentResistance = 0;
    int currentBreakPoint = 0;
    int currentAmmo = 0;
    std::string currentLED = "GREEN";
    bool gyroEnabled = false;
    float gyroSensitivity = 1.0f;

    void logMessage(const std::string& msg) {
        std::cout << "[DSX UDP] " << msg << std::endl;
    }

    void processCommand(const std::string& cmd) {
        if (cmd.find("TRIGGER:") == 0) {
            // Format: TRIGGER:resistance:break:ammo
            int res, brk, ammo;
            if (sscanf_s(cmd.c_str(), "TRIGGER:%d:%d:%d", &res, &brk, &ammo) == 3) {
                currentResistance = res;
                currentBreakPoint = brk;
                currentAmmo = ammo;
                logMessage("Trigger update: R=" + std::to_string(res) + 
                          " B=" + std::to_string(brk) + " Ammo=" + std::to_string(ammo));
                
                // In a real implementation, this would send commands to DSX
                // For demo purposes, we just log
            }
        }
        else if (cmd.find("LED:") == 0) {
            std::string color = cmd.substr(4);
            currentLED = color;
            logMessage("LED color: " + color);
        }
        else if (cmd.find("GYRO:") == 0) {
            int enabled;
            float sens;
            if (sscanf_s(cmd.c_str(), "GYRO:%d:%f", &enabled, &sens) == 2) {
                gyroEnabled = (enabled == 1);
                gyroSensitivity = sens;
                logMessage("Gyro: " + std::string(gyroEnabled ? "ON" : "OFF") + 
                          " Sens=" + std::to_string(sens));
            }
        }
    }

    void listenLoop() {
        char buffer[BUFFER_SIZE];
        sockaddr_in clientAddr;
        int clientAddrLen = sizeof(clientAddr);

        while (running) {
            int bytes = recvfrom(sock, buffer, BUFFER_SIZE - 1, 0, 
                                 (sockaddr*)&clientAddr, &clientAddrLen);
            if (bytes > 0) {
                buffer[bytes] = '\0';
                std::string cmd(buffer);
                processCommand(cmd);
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
        }
    }

public:
    DSXUDPClient() : sock(INVALID_SOCKET), running(false) {
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
            logMessage("WSAStartup failed");
        }
    }

    ~DSXUDPClient() {
        stop();
        WSACleanup();
    }

    bool start() {
        sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
        if (sock == INVALID_SOCKET) {
            logMessage("Socket creation failed");
            return false;
        }

        serverAddr.sin_family = AF_INET;
        serverAddr.sin_port = htons(DSX_UDP_PORT);
        inet_pton(AF_INET, "127.0.0.1", &serverAddr.sin_addr);

        // Bind to any port for receiving
        sockaddr_in localAddr;
        localAddr.sin_family = AF_INET;
        localAddr.sin_port = 0; // Any available port
        localAddr.sin_addr.s_addr = INADDR_ANY;
        
        if (bind(sock, (sockaddr*)&localAddr, sizeof(localAddr)) == SOCKET_ERROR) {
            logMessage("Bind failed");
            closesocket(sock);
            return false;
        }

        running = true;
        listenThread = std::thread(&DSXUDPClient::listenLoop, this);
        
        logMessage("UDP client started on port " + std::to_string(DSX_UDP_PORT));
        return true;
    }

    void stop() {
        running = false;
        if (listenThread.joinable()) {
            listenThread.join();
        }
        if (sock != INVALID_SOCKET) {
            closesocket(sock);
            sock = INVALID_SOCKET;
        }
        logMessage("UDP client stopped");
    }

    bool isRunning() const { return running; }
};

// Simple console UI
int main() {
    SetConsoleTitle(L"RE9 DualSense UDP Client");
    
    std::cout << "=========================================" << std::endl;
    std::cout << "RE9 DualSense UDP Client v1.0" << std::endl;
    std::cout << "=========================================" << std::endl;
    std::cout << "This client communicates between REFramework and DSX" << std::endl;
    std::cout << "to enable adaptive triggers on DualSense controllers." << std::endl;
    std::cout << std::endl;
    
    DSXUDPClient client;
    
    if (client.start()) {
        std::cout << "[OK] UDP client listening on port 26780" << std::endl;
        std::cout << std::endl;
        std::cout << "Waiting for data from REFramework..." << std::endl;
        std::cout << "Press Q to quit" << std::endl;
        std::cout << std::endl;
        
        // Create autorun shortcut (optional)
        std::cout << "To auto-start with Windows, copy this executable to:" << std::endl;
        std::cout << "  %APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\" << std::endl;
        std::cout << std::endl;
        
        while (true) {
            if (GetAsyncKeyState('Q') & 0x8000) {
                break;
            }
            Sleep(100);
        }
    } else {
        std::cout << "[ERROR] Failed to start UDP client" << std::endl;
        std::cout << "Press any key to exit..." << std::endl;
        std::cin.get();
        return 1;
    }
    
    client.stop();
    std::cout << "Client stopped. Goodbye!" << std::endl;
    return 0;
}