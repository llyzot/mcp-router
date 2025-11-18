#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const manifestPath = path.join(__dirname, '..', 'scoop', 'mcp-router.json');

if (!fs.existsSync(manifestPath)) {
  console.error('❌ Scoop manifest not found at:', manifestPath);
  process.exit(1);
}

try {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));

  // Validate required fields
  const requiredFields = ['version', 'description', 'homepage', 'license', 'architecture'];
  for (const field of requiredFields) {
    if (!(field in manifest)) {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  // Validate architecture.64bit
  if (!manifest.architecture['64bit']) {
    throw new Error('Missing 64bit architecture definition');
  }

  const arch64bit = manifest.architecture['64bit'];
  if (!arch64bit.url) {
    throw new Error('Missing url in 64bit architecture');
  }
  if (!arch64bit.hash) {
    throw new Error('Missing hash in 64bit architecture');
  }

  // Validate hash format
  if (!arch64bit.hash.startsWith('sha256:')) {
    throw new Error('Hash must start with "sha256:"');
  }

  console.log('✓ Scoop manifest is valid');
  console.log('  Version:', manifest.version);
  console.log('  Description:', manifest.description);
  console.log('  Download URL:', arch64bit.url);
  console.log('  SHA256:', arch64bit.hash);
} catch (error) {
  console.error('❌ Manifest validation failed:', error.message);
  process.exit(1);
}
