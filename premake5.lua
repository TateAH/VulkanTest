workspace "VulkanTest"
	architecture "x64"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["glm"] = "VulkanTest/Dependencies/glm"
IncludeDir["GLFW"] = "VulkanTest/Dependencies/GLFW/include"

include "VulkanTest/Dependencies/GLFW"

project "VulkanTest"
	location "VulkanTest"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin" .. outputdir .. "/%{prj.name}")

	pchheader "vkpch.h"
	pchsource "VulkanTest/src/vkpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/Dependencies/glm/glm/**.hpp",
		"%{prj.name}/Dependencies/glm/glm/**.inl"
	}

	defines
	{
		"VT_PLATFORM_WINDOWS",
		"VT_BUILD_DLL",
		"_CRT_SECURE_NO_WARNINGS"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/src/**.cpp",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.glm}"
	}

	links
	{
		"GLFW"
	}

	filter "system:windows"
		systemversion "latest"

		defines
		{
			GLFW_INCLUDE_NONE
		}

	filter "configurations:Debug"
		defines "VT_DEBUG"
		runtime "Debug"
		optimize "on"

	filter "configurations:Release"
		defines "VT_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "VT_DIST"
		runtime "Release"
		optimize "on"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "%{prj.name}")
	objdir ("bin/" .. outputdir .. "%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"VulkanTest/src",
		"VulkanTest/Dependencies",
		"%{IncludeDir.glm}"
	}

	links
	{
		"VulkanTest"
	}

		filter "system:windows"
		systemversion "latest"

		defines
		{
			"VT_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "VT_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "VT_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "VT_DIST"
		runtime "Release"
		optimize "on"
