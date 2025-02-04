# Copyright (C) 2025 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# TODO: b/390682260 move this file to the domain-agnostic common path once new repo is created

#
## user tasks configuration
#

ifeq ($(TRUSTY_SYSTEM_VM),nonsecure)
TRUSTY_VM_INCLUDE_HW_CRYPTO_HAL ?= true
TRUSTY_VM_INCLUDE_SECURE_STORAGE_HAL ?= true
# Derive RPMB key using HKDF
WITH_HKDF_RPMB_KEY ?= true
# Enable Secure Storage AIDL interface
STORAGE_AIDL_ENABLED ?= true
# nonsecure mode: FAKE HWKEY services
WITH_FAKE_HWRNG ?= true
WITH_FAKE_HWKEY ?= true
WITH_FAKE_KEYBOX ?= true
# Always allow provisioning for emulator builds
STATIC_SYSTEM_STATE_FLAG_PROVISIONING_ALLOWED := 1

# nonsecure KeyMint Trusty VM on x86_64 / cuttlefish
KEYMINT_TRUSTY_VM ?= nonsecure

else
# TODO(b/390206831): enable secure mode once the remote Trusted HAL services are supported
$(error TRUSTY_SYSTEM_VM shall be defined as nonsecure, until secure mode is supported)

endif

USE_SYSTEM_BINDER := true


#
## user tasks inclusion
#

TRUSTY_BUILTIN_USER_TASKS := \
	trusty/user/app/gatekeeper \
	trusty/user/app/keymint/app \

ifeq ($(TRUSTY_SYSTEM_VM),nonsecure)

# in nonsecure mode, include Trusted HAL service locally
TRUSTY_BUILTIN_USER_TASKS += \
	trusty/user/app/sample/hwaes \
	trusty/user/app/sample/hwbcc \
	trusty/user/app/sample/hwcrypto \
	trusty/user/app/sample/hwcryptohal/server/app \
	trusty/user/app/storage \
	trusty/user/base/app/system_state_server_static \

endif

## prebuilt
TRUSTY_PREBUILT_USER_TASKS :=
