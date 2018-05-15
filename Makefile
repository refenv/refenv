BUILD_ROOT := build
MACHINES_ROOT := machines
MACHINES := ${sort ${notdir ${wildcard ${MACHINES_ROOT}/*}}}

# These can can be overwritten via environment variables
export PACKER_KEY_INTERVAL ?= 10ms
export PACKER_ACCELERATOR ?= kvm
export PACKER_HEADLESS ?= true
export PACKER_CMD ?= packer
export PACKER_LOG ?= 0

# These must be overwritten via environment variables
export VAGRANT_CLOUD_USERNAME ?= GET_A_VAGRANT_CLOUD_ACCOUNT
export VAGRANT_CLOUD_TOKEN ?= GET_A_VAGRANT_CLOUD_TOKEN

# These will be set and controller by make
export MACHINE_NAME
export MACHINE_VER_MAJOR
export MACHINE_VER_MINOR
export MACHINE_VER_PATCH
export MACHINE_VERS

export MACHINE_BOX_PROVIDER
export MACHINE_QCOW2_PATH
export MACHINE_BOX_FNAME
export MACHINE_BOX_PATH

export PACKER_KEY_INTERVAL
export PACKER_ACCELERATOR
export PACKER_HEADLESS
export PACKER_CMD
export PACKER_LOG

default:
	@echo "# Usage examples"
	@echo "make all	# pack all machines"
	@echo "make ${word 1, ${MACHINES}}	# pack a single machine"

.PHONY: check
check:
	@echo "# Checking integrity of machine definitions"
	@./scripts/intc.py ${MACHINES_ROOT}

.PHONY: clean
clean:
	@echo "# clean"
	@echo "# removing: '${BUILD_ROOT}'"
	@rm -r ${BUILD_ROOT} || true
	@mkdir -p ${BUILD_ROOT}
	@touch ${BUILD_ROOT}/.keep

compare_base:
	meld machines/*-base

compare_mini:
	meld machines/*-mini

compare_wrks:
	meld machines/*-wrks

compare_qatd:
	meld machines/*-qatd

compare_u1604:
	meld machines/u1604-base machines/u1604-wrks machines/u1604-qatd

compare_u1804:
	meld machines/u1804-base machines/u1804-wrks machines/u1804-qatd

.PHONY: print
print:
	@echo "# MACHINE_NAME: ${MACHINE_NAME}"
	@echo "# MACHINE_VER_MAJOR: ${MACHINE_VER_MAJOR}"
	@echo "# MACHINE_VER_MINOR: ${MACHINE_VER_MINOR}"
	@echo "# MACHINE_VER_PATCH: ${MACHINE_VER_PATCH}"
	@echo "# MACHINE_VERS: ${MACHINE_VERS}"
	@echo "# MACHINE_QCOW2_PATH: ${MACHINE_QCOW2_PATH}"
	@echo "# MACHINE_BOX_PROVIDER: ${MACHINE_BOX_PROVIDER}"
	@echo "# MACHINE_BOX_FNAME: ${MACHINE_BOX_FNAME}"
	@echo "# MACHINE_BOX_PATH: ${MACHINE_BOX_PATH}"
	@echo "# PACKER_KEY_INTERVAL: ${PACKER_KEY_INTERVAL}"
	@echo "# PACKER_ACCELERATOR: ${PACKER_ACCELERATOR}"
	@echo "# PACKER_HEADLESS: ${PACKER_HEADLESS}"
	@echo "# PACKER_CMD: ${PACKER_CMD}"
	@echo "# PACKER_LOG: ${PACKER_LOG}"
	@echo "# VAGRANT_CLOUD_USERNAME: ${VAGRANT_CLOUD_USERNAME}"
	@echo "# VAGRANT_CLOUD_TOKEN: XXXXX"

.PHONY: version
version: configure
	@echo "# ${MACHINE_VERS}"
	$(eval MACHINE_VER_PATCH := `expr ${MACHINE_VER_PATCH} + 1`)
	echo ${MACHINE_VER_PATCH} > machines/${MACHINE_NAME}/ver.patch

.PHONY: bump
bump:
	@echo "# bumping up version for all machines"
	make u1604-base version
	make u1604-mini version
	make u1604-qatd version
	make u1604-wrks version
	make u1804-base version
	make u1804-mini version
	make u1804-qatd version
	make u1804-wrks version

.PHONY: configure
configure:
	@echo "## configure: ${MACHINE_NAME}"
	@[ ! "${MACHINE_NAME}" = "" ]
	@[ -d "machines/${MACHINE_NAME}" ]
	@[ -d "machines/${MACHINE_NAME}/pkgs" ]
	@[ -f "machines/${MACHINE_NAME}/tmpl.json" ]
	@[ -f "machines/${MACHINE_NAME}/ver.major" ]
	@[ -f "machines/${MACHINE_NAME}/ver.minor" ]
	@[ -f "machines/${MACHINE_NAME}/ver.patch" ]
	$(eval MACHINE_VER_MAJOR := ${shell cat machines/${MACHINE_NAME}/ver.major})
	$(eval MACHINE_VER_MINOR := ${shell cat machines/${MACHINE_NAME}/ver.minor})
	$(eval MACHINE_VER_PATCH := ${shell cat machines/${MACHINE_NAME}/ver.patch})
	$(eval MACHINE_VERS := ${MACHINE_VER_MAJOR}.${MACHINE_VER_MINOR}.${MACHINE_VER_PATCH})
	$(eval MACHINE_BOX_PROVIDER := libvirt)
	$(eval MACHINE_BOX_FNAME := ${MACHINE_NAME}.box)
	$(eval MACHINE_BOX_PATH := ${BUILD_ROOT}/${MACHINE_BOX_FNAME})
	$(eval MACHINE_QCOW2_PATH := ${BUILD_ROOT}/${MACHINE_NAME}.qcow2)

.PHONY: packer
packer: configure
	@echo "## packer: ${MACHINE_NAME}"
	@[ -d "machines/${MACHINE_NAME}" ]

	/usr/bin/time ${PACKER_CMD} build machines/${MACHINE_NAME}/tmpl.json
	@echo "# qemu-img: ${MACHINE_NAME}"
	/usr/bin/time qemu-img convert -O qcow2 -c ${BUILD_ROOT}/${MACHINE_NAME}-qemu/${MACHINE_NAME} ${BUILD_ROOT}/${MACHINE_NAME}.qcow2
	md5sum ${BUILD_ROOT}/${MACHINE_NAME}.qcow2 > ${BUILD_ROOT}/${MACHINE_NAME}.qcow2.md5

.PHONY: $(MACHINES)
$(MACHINES) : % : machines/%
	$(eval MACHINE_NAME := $@)

.PHONY: u1604
pack-u1604:
	@echo "# u1604 -- begin"
	make u1604-base packer || true
	make u1604-mini packer || true
	make u1604-wrks packer || true
	make u1604-qatd packer || true
	@echo "# u1604 -- done"

.PHONY: u1804
pack-u1804:
	@echo "# u1804 -- begin"
	make u1804-base packer || true
	make u1804-mini packer || true
	make u1804-wrks packer || true
	make u1804-qatd packer || true
	@echo "# u1804 -- done"

# Start the machine using vagrant
.PHONY: run-vagrant
run-vagrant: configure print
	@echo "## vagrant: ${MACHINE_NAME}"
	cd ~/Vagrant && vagrant halt || true
	cd ~/Vagrant && vagrant destroy || true
	rm -r ~/Vagrant
	mkdir ~/Vagrant
	[ -f "${MACHINE_BOX_PATH}" ] && cp ${MACHINE_BOX_PATH} ~/Vagrant/ || true
	cd ~/Vagrant && vagrant box add ${MACHINE_BOX_FNAME} --name ${MACHINE_NAME} --provider=${MACHINE_BOX_PROVIDER} -f
	cd ~/Vagrant && vagrant init ${MACHINE_NAME}
	cd ~/Vagrant && vagrant up
	cd ~/Vagrant && vagrant status

# Start the machine in build/ with qemu
.PHONY: run-qemu
run-qemu: configure print
	@echo "## qemu: ${MACHINE_NAME}"
	qemu-system-x86_64 \
		-cpu core2duo \
		-hda ${MACHINE_QCOW2_PATH} \
		-net nic -net user \
		-enable-kvm \
		-m 4096 \
		--enable-kvm \
		-curses \
		-vnc :0

.PHONY: upload-vcloud
upload-vcloud: configure print
	@echo "## vagrant-cloud: ${MACHINE_NAME}"
	[ -f ${MACHINE_BOX_PATH} ]
	./dist/vcloud.py
