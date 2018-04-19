// Copyright 1998-2018 Epic Games, Inc. All Rights Reserved.
/*===========================================================================
	Generated code exported from UnrealHeaderTool.
	DO NOT modify this manually! Edit the corresponding .h files instead!
===========================================================================*/

#include "GeneratedCppIncludes.h"
#include "UnrealSketchingGameModeBase.h"
#ifdef _MSC_VER
#pragma warning (push)
#pragma warning (disable : 4883)
#endif
PRAGMA_DISABLE_DEPRECATION_WARNINGS
void EmptyLinkFunctionForGeneratedCodeUnrealSketchingGameModeBase() {}
// Cross Module References
	UNREALSKETCHING_API UClass* Z_Construct_UClass_AUnrealSketchingGameModeBase_NoRegister();
	UNREALSKETCHING_API UClass* Z_Construct_UClass_AUnrealSketchingGameModeBase();
	ENGINE_API UClass* Z_Construct_UClass_AGameModeBase();
	UPackage* Z_Construct_UPackage__Script_UnrealSketching();
// End Cross Module References
	void AUnrealSketchingGameModeBase::StaticRegisterNativesAUnrealSketchingGameModeBase()
	{
	}
	UClass* Z_Construct_UClass_AUnrealSketchingGameModeBase_NoRegister()
	{
		return AUnrealSketchingGameModeBase::StaticClass();
	}
	UClass* Z_Construct_UClass_AUnrealSketchingGameModeBase()
	{
		static UClass* OuterClass = nullptr;
		if (!OuterClass)
		{
			static UObject* (*const DependentSingletons[])() = {
				(UObject* (*)())Z_Construct_UClass_AGameModeBase,
				(UObject* (*)())Z_Construct_UPackage__Script_UnrealSketching,
			};
#if WITH_METADATA
			static const UE4CodeGen_Private::FMetaDataPairParam Class_MetaDataParams[] = {
				{ "HideCategories", "Info Rendering MovementReplication Replication Actor Input Movement Collision Rendering Utilities|Transformation" },
				{ "IncludePath", "UnrealSketchingGameModeBase.h" },
				{ "ModuleRelativePath", "UnrealSketchingGameModeBase.h" },
				{ "ShowCategories", "Input|MouseInput Input|TouchInput" },
			};
#endif
			static const FCppClassTypeInfoStatic StaticCppClassTypeInfo = {
				TCppClassTypeTraits<AUnrealSketchingGameModeBase>::IsAbstract,
			};
			static const UE4CodeGen_Private::FClassParams ClassParams = {
				&AUnrealSketchingGameModeBase::StaticClass,
				DependentSingletons, ARRAY_COUNT(DependentSingletons),
				0x00900288u,
				nullptr, 0,
				nullptr, 0,
				nullptr,
				&StaticCppClassTypeInfo,
				nullptr, 0,
				METADATA_PARAMS(Class_MetaDataParams, ARRAY_COUNT(Class_MetaDataParams))
			};
			UE4CodeGen_Private::ConstructUClass(OuterClass, ClassParams);
		}
		return OuterClass;
	}
	IMPLEMENT_CLASS(AUnrealSketchingGameModeBase, 1257924618);
	static FCompiledInDefer Z_CompiledInDefer_UClass_AUnrealSketchingGameModeBase(Z_Construct_UClass_AUnrealSketchingGameModeBase, &AUnrealSketchingGameModeBase::StaticClass, TEXT("/Script/UnrealSketching"), TEXT("AUnrealSketchingGameModeBase"), false, nullptr, nullptr, nullptr);
	DEFINE_VTABLE_PTR_HELPER_CTOR(AUnrealSketchingGameModeBase);
PRAGMA_ENABLE_DEPRECATION_WARNINGS
#ifdef _MSC_VER
#pragma warning (pop)
#endif
