
#define WIN32_LEAN_AND_MEAN
#define IMPLEMENT_API
#include <Windows.h>
#include <Xinput.h>
#pragma comment(lib, "XInput.lib")
#include <hx\CFFI.h>
#include <stdio.h>
#include <stdlib.h>

#include <array>

using namespace std;

extern "C" {
	static void vibrate(value controllerID, value left, value right){
		XINPUT_VIBRATION Vibration;
		ZeroMemory(&Vibration, sizeof(XINPUT_VIBRATION));
		Vibration.wLeftMotorSpeed = static_cast<DWORD>(val_int(left));
		Vibration.wRightMotorSpeed = static_cast<DWORD>(val_int(right));
		XInputSetState(static_cast<DWORD>(val_int(controllerID)), &Vibration);
	}
	static inline int boolToInt(bool b){
		return b?1:0;
	}
	static value poll(value controllerID){
		XINPUT_STATE state;
		ZeroMemory(&state, sizeof(XINPUT_STATE));
		DWORD Result = XInputGetState(static_cast<DWORD>(val_int(controllerID)), &state);

		value outArray = alloc_array(20);
		val_array_set_i(outArray, 0, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_UP)); //XINPUT_GAMEPAD_DPAD_UP
		val_array_set_i(outArray, 1, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_DOWN)); //XINPUT_GAMEPAD_DPAD_DOWN
		val_array_set_i(outArray, 2, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_LEFT)); //XINPUT_GAMEPAD_DPAD_LEFT
		val_array_set_i(outArray, 3, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT)); //XINPUT_GAMEPAD_DPAD_RIGHT
		val_array_set_i(outArray, 4, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_START)); //XINPUT_GAMEPAD_START
		val_array_set_i(outArray, 5, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_BACK)); //XINPUT_GAMEPAD_BACK
		val_array_set_i(outArray, 6, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_LEFT_THUMB)); //XINPUT_GAMEPAD_LEFT_THUMB
		val_array_set_i(outArray, 7, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB)); //XINPUT_GAMEPAD_RIGHT_THUMB
		val_array_set_i(outArray, 8, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER)); //XINPUT_GAMEPAD_LEFT_SHOULDER
		val_array_set_i(outArray, 9, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER)); //XINPUT_GAMEPAD_RIGHT_SHOULDER
		val_array_set_i(outArray, 10, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_A)); //XINPUT_GAMEPAD_A
		val_array_set_i(outArray, 11, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_B)); //XINPUT_GAMEPAD_B
		val_array_set_i(outArray, 12, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_X)); //XINPUT_GAMEPAD_X
		val_array_set_i(outArray, 13, alloc_int(state.Gamepad.wButtons & XINPUT_GAMEPAD_Y)); //XINPUT_GAMEPAD_Y

		val_array_set_i(outArray, 14, alloc_int(static_cast<int>(state.Gamepad.bLeftTrigger))); //left trigger
		val_array_set_i(outArray, 15, alloc_int(static_cast<int>(state.Gamepad.bRightTrigger))); //right trigger

		val_array_set_i(outArray, 16, alloc_int(static_cast<int>(state.Gamepad.sThumbLX))); //left stickX
		val_array_set_i(outArray, 17, alloc_int(static_cast<int>(state.Gamepad.sThumbLY))); //left stickY
		val_array_set_i(outArray, 18, alloc_int(static_cast<int>(state.Gamepad.sThumbRX))); //right stickX
		val_array_set_i(outArray, 19, alloc_int(static_cast<int>(state.Gamepad.sThumbRY))); //right stickY

		return outArray;
	}
	static value isConnected(value controllerID){
		XINPUT_STATE state;
		ZeroMemory(&state, sizeof(XINPUT_STATE));
		DWORD Result = XInputGetState(static_cast<DWORD>(val_int(controllerID)), &state);
		if(Result == ERROR_DEVICE_NOT_CONNECTED) return alloc_bool(false);
		return alloc_bool(true);

	}
}
DEFINE_PRIM(vibrate, 3);
DEFINE_PRIM(isConnected, 1);
DEFINE_PRIM(poll, 1);