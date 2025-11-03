# GitHub Secrets セットアップ手順

## google-services.json を GitHub Secrets に保存する方法

CI/CDでビルドするために、`google-services.json`をGitHub Secretsに保存する必要があります。

### 方法1: Base64エンコードして保存（推奨）

1. ローカルで`google-services.json`をBase64エンコード:
   ```bash
   # Windows (PowerShell)
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/google-services.json"))

   # macOS/Linux
   base64 -i android/app/google-services.json
   ```

2. GitHubリポジトリのSettings → Secrets and variables → Actions に移動

3. "New repository secret" をクリック

4. 以下を入力:
   - Name: `GOOGLE_SERVICES_JSON`
   - Secret: 上記で取得したBase64エンコードされた文字列

5. "Add secret" をクリック

### 方法2: JSONをそのまま保存

GitHub Secretsは長い文字列にも対応しているので、Base64エンコードせずにJSONをそのまま保存することも可能です。

その場合は、`.github/workflow/main.yml`のステップを以下のように変更してください:

```yaml
- name: Setup Google Services JSON
  run: |
    echo "${{ secrets.GOOGLE_SERVICES_JSON }}" > android/app/google-services.json
  shell: bash
```

