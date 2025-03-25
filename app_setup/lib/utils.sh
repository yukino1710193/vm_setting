#!/bin/bash
# ==================== UTILITY FUNCTIONS ====================

dedup_path() {
    export PATH=$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)
}
