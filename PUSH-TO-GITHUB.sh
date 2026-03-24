#!/bin/bash
# Script to push to GitHub

echo "🚀 Pushing to GitHub..."

# Add remote (if not exists)
git remote add origin https://github.com/moringaiq2017-oss/education-app.git 2>/dev/null || echo "Remote 'origin' already exists"

# Push to main
git push -u origin main

echo "✅ Done! Check: https://github.com/moringaiq2017-oss/education-app"
