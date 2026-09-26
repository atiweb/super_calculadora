#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  // Portrait, phone-like window (the keypads are designed for it), clamped to
  // the work area so it fits on a short laptop screen with 150% scaling.
  // Create() takes logical pixels and scales them by the monitor's DPI.
  RECT work_area;
  unsigned int window_height = 780;
  if (::SystemParametersInfo(SPI_GETWORKAREA, 0, &work_area, 0)) {
    const unsigned int dpi = ::GetDpiForSystem();
    const unsigned int available =
        (work_area.bottom - work_area.top) * 96 / (dpi ? dpi : 96);
    if (available > 80 && available - 40 < window_height) {
      window_height = available - 40;
    }
  }
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(430, window_height);
  if (!window.Create(L"Super Calculadora", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
