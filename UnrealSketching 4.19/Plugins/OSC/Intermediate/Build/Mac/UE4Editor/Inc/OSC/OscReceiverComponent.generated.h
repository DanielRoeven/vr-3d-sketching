// Copyright 1998-2018 Epic Games, Inc. All Rights Reserved.
/*===========================================================================
	Generated code exported from UnrealHeaderTool.
	DO NOT modify this manually! Edit the corresponding .h files instead!
===========================================================================*/

#include "ObjectMacros.h"
#include "ScriptMacros.h"

PRAGMA_DISABLE_DEPRECATION_WARNINGS
struct FOscDataElemStruct;
#ifdef OSC_OscReceiverComponent_generated_h
#error "OscReceiverComponent.generated.h already included, missing '#pragma once' in OscReceiverComponent.h"
#endif
#define OSC_OscReceiverComponent_generated_h

#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_10_DELEGATE \
struct _Script_OSC_eventComponentOscReceivedSignature_Parms \
{ \
	FName Address; \
	TArray<FOscDataElemStruct> Data; \
	FString SenderIp; \
}; \
static inline void FComponentOscReceivedSignature_DelegateWrapper(const FMulticastScriptDelegate& ComponentOscReceivedSignature, FName const& Address, TArray<FOscDataElemStruct> const& Data, const FString& SenderIp) \
{ \
	_Script_OSC_eventComponentOscReceivedSignature_Parms Parms; \
	Parms.Address=Address; \
	Parms.Data=Data; \
	Parms.SenderIp=SenderIp; \
	ComponentOscReceivedSignature.ProcessMulticastDelegate<UObject>(&Parms); \
}


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_RPC_WRAPPERS
#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_RPC_WRAPPERS_NO_PURE_DECLS
#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_INCLASS_NO_PURE_DECLS \
private: \
	static void StaticRegisterNativesUOscReceiverComponent(); \
	friend OSC_API class UClass* Z_Construct_UClass_UOscReceiverComponent(); \
public: \
	DECLARE_CLASS(UOscReceiverComponent, UActorComponent, COMPILED_IN_FLAGS(0), 0, TEXT("/Script/OSC"), NO_API) \
	DECLARE_SERIALIZER(UOscReceiverComponent) \
	enum {IsIntrinsic=COMPILED_IN_INTRINSIC};


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_INCLASS \
private: \
	static void StaticRegisterNativesUOscReceiverComponent(); \
	friend OSC_API class UClass* Z_Construct_UClass_UOscReceiverComponent(); \
public: \
	DECLARE_CLASS(UOscReceiverComponent, UActorComponent, COMPILED_IN_FLAGS(0), 0, TEXT("/Script/OSC"), NO_API) \
	DECLARE_SERIALIZER(UOscReceiverComponent) \
	enum {IsIntrinsic=COMPILED_IN_INTRINSIC};


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_STANDARD_CONSTRUCTORS \
	/** Standard constructor, called after all reflected properties have been initialized */ \
	NO_API UOscReceiverComponent(const FObjectInitializer& ObjectInitializer); \
	DEFINE_DEFAULT_OBJECT_INITIALIZER_CONSTRUCTOR_CALL(UOscReceiverComponent) \
DEFINE_VTABLE_PTR_HELPER_CTOR_CALLER(UOscReceiverComponent); \
private: \
	/** Private move- and copy-constructors, should never be used */ \
	NO_API UOscReceiverComponent(UOscReceiverComponent&&); \
	NO_API UOscReceiverComponent(const UOscReceiverComponent&); \
public:


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_ENHANCED_CONSTRUCTORS \
private: \
	/** Private move- and copy-constructors, should never be used */ \
	NO_API UOscReceiverComponent(UOscReceiverComponent&&); \
	NO_API UOscReceiverComponent(const UOscReceiverComponent&); \
public: \
DEFINE_VTABLE_PTR_HELPER_CTOR_CALLER(UOscReceiverComponent); \
	DEFINE_DEFAULT_CONSTRUCTOR_CALL(UOscReceiverComponent)


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_PRIVATE_PROPERTY_OFFSET
#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_13_PROLOG
#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_GENERATED_BODY_LEGACY \
PRAGMA_DISABLE_DEPRECATION_WARNINGS \
public: \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_PRIVATE_PROPERTY_OFFSET \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_RPC_WRAPPERS \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_INCLASS \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_STANDARD_CONSTRUCTORS \
public: \
PRAGMA_ENABLE_DEPRECATION_WARNINGS


#define UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_GENERATED_BODY \
PRAGMA_DISABLE_DEPRECATION_WARNINGS \
public: \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_PRIVATE_PROPERTY_OFFSET \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_RPC_WRAPPERS_NO_PURE_DECLS \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_INCLASS_NO_PURE_DECLS \
	UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h_16_ENHANCED_CONSTRUCTORS \
private: \
PRAGMA_ENABLE_DEPRECATION_WARNINGS


#undef CURRENT_FILE_ID
#define CURRENT_FILE_ID UnrealSketching_4_19_Plugins_OSC_Source_OSC_Public_Receive_OscReceiverComponent_h


PRAGMA_ENABLE_DEPRECATION_WARNINGS
