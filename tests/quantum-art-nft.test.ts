import { describe, it, expect, beforeEach } from 'vitest';

// Simulated contract state
let lastTokenId = 0;
const tokenMetadata = new Map();
const tokenOwners = new Map();

// Simulated contract functions
function mint(name: string, description: string, artworkId: number, imageUrl: string, quantumEntropy: string, universeId: number, artist: string) {
  const tokenId = ++lastTokenId;
  tokenMetadata.set(tokenId, {
    name,
    description,
    artist,
    artworkId,
    imageUrl,
    quantumEntropy,
    universeId
  });
  tokenOwners.set(tokenId, artist);
  return tokenId;
}

function transfer(tokenId: number, sender: string, recipient: string) {
  if (tokenOwners.get(tokenId) !== sender) throw new Error('Not authorized');
  tokenOwners.set(tokenId, recipient);
  return true;
}

describe('Quantum Art NFT Contract', () => {
  beforeEach(() => {
    lastTokenId = 0;
    tokenMetadata.clear();
    tokenOwners.clear();
  });
  
  it('should mint a new quantum art NFT', () => {
    const tokenId = mint('Quantum Superposition', 'An artwork existing in multiple states', 1, 'https://example.com/quantum.png', '0x1234567890abcdef', 1, 'artist1');
    expect(tokenId).toBe(1);
    expect(tokenOwners.get(tokenId)).toBe('artist1');
    const metadata = tokenMetadata.get(tokenId);
    expect(metadata.name).toBe('Quantum Superposition');
    expect(metadata.artworkId).toBe(1);
  });
  
  it('should transfer an NFT', () => {
    const tokenId = mint('Entangled Realities', 'Two intertwined universes', 2, 'https://example.com/entangled.png', '0xfedcba9876543210', 2, 'artist2');
    expect(transfer(tokenId, 'artist2', 'collector1')).toBe(true);
    expect(tokenOwners.get(tokenId)).toBe('collector1');
  });
  
  it('should not allow unauthorized transfer', () => {
    const tokenId = mint('Quantum Tunneling', 'Particles defying classical physics', 3, 'https://example.com/tunneling.png', '0xaabbccddee112233', 3, 'artist3');
    expect(() => transfer(tokenId, 'unauthorized_user', 'collector2')).toThrow('Not authorized');
  });
  
  it('should store correct metadata', () => {
    const imageUrl = 'https://example.com/multiverse.png';
    const quantumEntropy = '0x9988776655443322';
    const universeId = 4;
    const tokenId = mint('Multiverse Tapestry', 'A woven fabric of parallel universes', 4, imageUrl, quantumEntropy, universeId, 'artist4');
    const metadata = tokenMetadata.get(tokenId);
    expect(metadata.imageUrl).toBe(imageUrl);
    expect(metadata.quantumEntropy).toBe(quantumEntropy);
    expect(metadata.universeId).toBe(universeId);
  });
});
