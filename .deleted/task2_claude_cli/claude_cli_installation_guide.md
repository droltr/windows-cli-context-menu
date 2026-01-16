# Claude CLI (Code) Kurulum ve Test Rehberi

## ✅ DURUM: KONTROL EDİLDİ
## Tarih: 2025-12-22 17:49:45
## Rapor: claude_cli_test_20251222_174945.txt

---

# Claude CLI (Code) Kurulum ve Test Rehberi

## Tarih: 2025-12-22

## Claude CLI Nedir?

Claude CLI (resmi adı: Claude Code), Anthropic tarafından geliştirilen komut satırı aracıdır. Terminal üzerinden doğrudan Claude'a kodlama görevleri verebilirsiniz.

## Kurulum Adımları

### Ön Gereksinimler

```powershell
# Node.js versiyonunu kontrol (minimum v18 gerekli)
node --version

# NPM versiyonunu kontrol
npm --version

# Eğer Node.js yüklü değilse: https://nodejs.org/ adresinden LTS versiyonunu indirin
```

### Adım 1: Claude CLI Kurulumu

**UYARI:** 2025-12-22 itibariyle Claude CLI'nin resmi durumunu kontrol etmek gerekiyor. Anthropic'in resmi CLI aracı henüz public beta aşamasında olabilir.

#### Seçenek A: NPM ile Global Kurulum (Eğer mevcutsa)

```powershell
# Claude CLI'yi global olarak yükle
npm install -g @anthropic-ai/claude-cli

# Versiyonu kontrol
claude --version
```

#### Seçenek B: NPX ile Kullanım (Kurulum gerektirmez)

```powershell
# NPX ile doğrudan çalıştır
npx @anthropic-ai/claude-cli --version
```

#### Seçenek C: Manuel Kurulum (GitHub'dan)

```powershell
# Git ile klonla
git clone https://github.com/anthropics/anthropic-cli.git
cd anthropic-cli

# Bağımlılıkları yükle
npm install

# Build et
npm run build

# Global link oluştur
npm link
```

### Adım 2: API Key Yapılandırması

```powershell
# Environment variable olarak ayarla (Geçici - sadece mevcut session için)
$env:ANTHROPIC_API_KEY = "your-api-key-here"

# Kalıcı olarak ayarlamak için System Properties'den:
# 1. Windows tuşu + Pause/Break
# 2. Advanced system settings
# 3. Environment Variables
# 4. New (User variables altına)
# 5. Variable name: ANTHROPIC_API_KEY
# 6. Variable value: your-api-key-here

# Veya PowerShell profili ile kalıcı yap:
Add-Content $PROFILE "`n`$env:ANTHROPIC_API_KEY = 'your-api-key-here'"
```

### Adım 3: İlk Test

```powershell
# Basit bir test komutu
claude "Merhaba, benim adım Murat ve bir test yapıyorum"

# Kod yazdırma testi
claude "Python ile 1'den 10'a kadar olan sayıların toplamını hesaplayan bir fonksiyon yaz"

# Dosya okuma testi (eğer destekleniyorsa)
claude "Bu dosyayı analiz et: test.py"
```

## Test Senaryoları

### Test 1: Basit Sorgu

```powershell
Write-Host "=== Test 1: Basit Sorgu ==="
claude "2+2 kaçtır?" | Out-File -FilePath "test1_output.txt" -Encoding UTF8
Get-Content "test1_output.txt"
```

### Test 2: Kod Üretimi

```powershell
Write-Host "=== Test 2: Kod Üretimi ==="
claude "Python ile bubble sort algoritması yaz" | Out-File -FilePath "test2_bubblesort.py" -Encoding UTF8
Get-Content "test2_bubblesort.py"
```

### Test 3: Kod Analizi

```powershell
Write-Host "=== Test 3: Kod Analizi ==="

# Örnek bir kod dosyası oluştur
@"
def calculate(x, y):
    result = x + y
    return result

print(calculate(5, 3))
"@ | Out-File -FilePath "sample.py" -Encoding UTF8

# Claude'a analiz ettir
claude "Bu Python kodunu analiz et ve iyileştirme önerileri sun: $(Get-Content sample.py -Raw)"
```

### Test 4: Interactive Mode (Eğer destekleniyorsa)

```powershell
Write-Host "=== Test 4: Interactive Mode ==="
claude --interactive
# Veya
claude -i
```

## Sorun Giderme

### Hata 1: "claude: command not found"

**Çözüm:**
```powershell
# NPM global bin path'ini kontrol et
npm config get prefix

# PATH'e ekle (geçici)
$env:PATH += ";$(npm config get prefix)"

# Kalıcı olarak ekle (System Properties > Environment Variables)
```

### Hata 2: "API Key not found"

**Çözüm:**
```powershell
# Environment variable'ı kontrol et
Get-ChildItem Env: | Where-Object {$_.Name -like "*ANTHROPIC*"}

# Eğer yoksa, yeniden ayarla
[System.Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'your-key', 'User')
```

### Hata 3: Network/SSL Hataları

**Çözüm:**
```powershell
# Proxy ayarlarını kontrol et
netsh winhttp show proxy

# Node.js SSL sertifika kontrolünü devre dışı bırak (güvenli olmayan, sadece test için)
$env:NODE_TLS_REJECT_UNAUTHORIZED = "0"
```

## Kullanım İpuçları

### 1. Output'u Dosyaya Kaydetme

```powershell
claude "Görev açıklaması" | Out-File -FilePath "output.txt" -Encoding UTF8
```

### 2. Piping ve Chaining

```powershell
# Bir dosyayı oku ve Claude'a gönder
Get-Content "input.txt" -Raw | claude "Bu metni özetle"

# Claude'un çıktısını başka bir komuta gönder
claude "10 rastgele sayı üret" | Select-String "\d+"
```

### 3. Batch Processing

```powershell
# Birden fazla dosyayı işle
Get-ChildItem "*.py" | ForEach-Object {
    $output = claude "Bu Python dosyasını analiz et: $(Get-Content $_.FullName -Raw)"
    $output | Out-File -FilePath "$($_.BaseName)_analysis.txt" -Encoding UTF8
}
```

## Kapsamlı Test Scripti

```powershell
# Tüm testleri çalıştır ve raporla
$testResults = @()

Write-Host "Claude CLI Kapsamlı Test Başlıyor..." -ForegroundColor Cyan

# Test 1: Version Check
try {
    $version = claude --version 2>&1
    $testResults += [PSCustomObject]@{
        Test = "Version Check"
        Status = if($LASTEXITCODE -eq 0) {"PASS"} else {"FAIL"}
        Output = $version
    }
} catch {
    $testResults += [PSCustomObject]@{
        Test = "Version Check"
        Status = "FAIL"
        Output = $_.Exception.Message
    }
}

# Test 2: Simple Query
try {
    $query = claude "2+2 kaçtır?" 2>&1
    $testResults += [PSCustomObject]@{
        Test = "Simple Query"
        Status = if($query -match "4") {"PASS"} else {"PARTIAL"}
        Output = $query.Substring(0, [Math]::Min(100, $query.Length))
    }
} catch {
    $testResults += [PSCustomObject]@{
        Test = "Simple Query"
        Status = "FAIL"
        Output = $_.Exception.Message
    }
}

# Test 3: Code Generation
try {
    $code = claude "Python ile hello world" 2>&1
    $testResults += [PSCustomObject]@{
        Test = "Code Generation"
        Status = if($code -match "print") {"PASS"} else {"PARTIAL"}
        Output = $code.Substring(0, [Math]::Min(100, $code.Length))
    }
} catch {
    $testResults += [PSCustomObject]@{
        Test = "Code Generation"
        Status = "FAIL"
        Output = $_.Exception.Message
    }
}

# Sonuçları görüntüle
$testResults | Format-Table -AutoSize
$testResults | Export-Csv -Path "claude_cli_test_results_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv" -NoTypeInformation -Encoding UTF8

Write-Host "`nTest tamamlandı. Sonuçlar kaydedildi." -ForegroundColor Green
```

## Alternatif: Claude API ile Python CLI

Eğer resmi CLI aracı mevcut değilse, kendiniz basit bir CLI oluşturabilirsiniz:

```python
# claude_cli.py
import anthropic
import sys
import os

def main():
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        print("HATA: ANTHROPIC_API_KEY environment variable tanımlı değil!")
        sys.exit(1)
    
    client = anthropic.Anthropic(api_key=api_key)
    
    # Komut satırından gelen tüm argümanları birleştir
    prompt = " ".join(sys.argv[1:])
    
    if not prompt:
        print("Kullanım: python claude_cli.py <sorgunuz>")
        sys.exit(1)
    
    message = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    
    print(message.content[0].text)

if __name__ == "__main__":
    main()
```

Kullanımı:
```powershell
# Bağımlılıkları yükle
pip install anthropic

# Çalıştır
python claude_cli.py "Merhaba Claude!"
```

## Sonuç

Bu prosedürü tamamladıktan sonra:
1. Test sonuçlarını paylaşın
2. Karşılaştığınız hataları belirtin
3. Claude CLI'nin hangi versiyonunu kullandığınızı belirtin

**NOT:** 2025-12-22 itibariyle Claude CLI'nin tam adı ve kurulum yöntemi Anthropic'in güncel dokümantasyonundan teyit edilmelidir.

