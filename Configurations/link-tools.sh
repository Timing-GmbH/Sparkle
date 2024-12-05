#!/bin/sh

# If Carthage is trying to build us, it won't preserve code signing information from our bundled tools properly
# Building Sparkle from source with Carthage is thus not supported
if [ "$CARTHAGE" = "YES" ]; then
    echo "Error: Building Sparkle from source using Carthage is not supported. Please visit https://sparkle-project.org/documentation/ for proper Carthage integration."
    exit 1
fi

# Create symlinks to our helper tools in Sparkle framework bundle
# so URLForAuxiliaryExecutable: will pick up the tools. Doing this is supported in the Code Signing in Depth guide.

FRAMEWORK_PATH="${TARGET_BUILD_DIR}"/"${FULL_PRODUCT_NAME}"

# Skip if configuration is debug and the targets exist already; together with similar changes in Sparkle's other build
# scripts, this can help speed up the iteration time for debug builds by avoiding having to re-copy and re-code-sign the
# framework and its contents upon every build.
if [[ "$CONFIGURATION" == "Debug" && -e "${FRAMEWORK_PATH}"/"${SPARKLE_RELAUNCH_TOOL_NAME}" && -e "${FRAMEWORK_PATH}"/"${SPARKLE_INSTALLER_PROGRESS_TOOL_NAME}".app ]]; then
    echo "Skipping linking of (already-linked) Sparkle tools for Debug configuration to reduce build iteration time"
    exit 0
fi

ln -h -f -s "Versions/Current/""${SPARKLE_RELAUNCH_TOOL_NAME}" "${FRAMEWORK_PATH}"/"${SPARKLE_RELAUNCH_TOOL_NAME}"
ln -h -f -s "Versions/Current/""${SPARKLE_INSTALLER_PROGRESS_TOOL_NAME}".app "${FRAMEWORK_PATH}"/"${SPARKLE_INSTALLER_PROGRESS_TOOL_NAME}".app
