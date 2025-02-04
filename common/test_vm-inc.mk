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

# TODO(b/390206831): enable secure mode once the remote Trusted HAL services are supported
# secure mode will consist in removing the Trusted HAL services from the test VM
ifneq ($(TRUSTY_SYSTEM_VM),nonsecure)
$(error TRUSTY_SYSTEM_VM shall be defined as nonsecure)
endif

#
## debug configuration
#

KERNEL_INLINE_FUNCTIONS := false
USERSPACE_INLINE_FUNCTIONS := false
UBSAN_ENABLED ?= true
TEST_BUILD := true
SYMTAB_ENABLED ?= true

#
## user tasks configuration
#

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

USE_SYSTEM_BINDER := true

WITH_HWCRYPTO_UNITTEST := 1

# Enable hwcrypto unittest keyslots and tests
GLOBAL_USER_COMPILEFLAGS += -DWITH_HWCRYPTO_UNITTEST=$(WITH_HWCRYPTO_UNITTEST)


#
## user tasks inclusion
#

TRUSTY_BUILTIN_USER_TASKS := \
	trusty/user/app/gatekeeper \
	trusty/user/app/keymint/app \
	trusty/user/app/sample/hwaes \
	trusty/user/app/sample/hwbcc \
	trusty/user/app/sample/hwcrypto \
	trusty/user/app/sample/hwcryptohal/server/app \
	trusty/user/app/storage \
	trusty/user/base/app/apploader \
	trusty/user/base/app/device_tree \
	trusty/user/base/app/metrics \
	trusty/user/base/app/system_state_server_static \

ifeq (true,$(call TOBOOL,$(USER_COVERAGE_ENABLED)))
TRUSTY_ALL_USER_TASKS += \
	trusty/user/base/app/coverage \

endif

ifeq (true,$(call TOBOOL,$(UNITTEST_COVERAGE_ENABLED)))
TRUSTY_ALL_USER_TASKS += \
	trusty/user/base/app/line-coverage \

endif

#
## test user tasks inclusion
#
include frameworks/native/libs/binder/trusty/usertests-inc.mk
include trusty/kernel/kerneltests-inc.mk
include trusty/user/base/usertests-inc.mk
include trusty/user/base/usertests-rust-inc.mk

## prebuilt
TRUSTY_PREBUILT_USER_TASKS :=
