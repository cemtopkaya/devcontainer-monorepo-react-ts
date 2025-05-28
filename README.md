# Monorepo Kurulumu ve Bileşen/Web Uygulaması Oluşturma

Bu proje, bir monorepo yapısı altında React bileşenleri ve web uygulamaları geliştirmek için yapılandırılmıştır. Paket yönetimi için [pnpm](https://pnpm.io/), uygulama çatısı için [Vite](https://vitejs.dev/) ve bileşenler için TypeScript kullanılmaktadır.

## Klasör Yapısı

```
workspace/
├── apps/         # Web uygulamaları burada bulunur
├── packages/     # Paylaşımlı React bileşenleri burada bulunur
├── pnpm-workspace.yaml
└── package.json
```

## Otomasyon: postcreate.sh

Tüm kurulum ve örnek bileşen/uygulama oluşturma işlemleri `.devcontainer/postcreate.sh` betiği ile otomatikleştirilmiştir. Bu betik şunları yapar:

1. Gerekli dizinleri oluşturur (`apps/`, `packages/`).
2. Monorepo için pnpm workspace dosyasını (`pnpm-workspace.yaml`) oluşturur.
3. Ana `package.json` dosyasını başlatır.
4. Örnek bir React bileşeni (`comp1`) oluşturur:
    - TypeScript yapılandırması ve örnek bir React fonksiyonel bileşeni ekler.
    - Gerekli bağımlılıkları ve script'leri ekler.
    - Bileşeni workspace'e ekler.
5. Örnek bir web uygulaması (`comp1-app`) oluşturur:
    - Vite + React + TypeScript template'i ile başlatılır.
    - Bileşeni kullanacak şekilde örnek bir `App.tsx` dosyası ekler.
    - Gerekli script'leri ekler.

## Yeni Bileşen Oluşturma

Yeni bir bileşen eklemek için aşağıdaki adımlar izlenir:

1. `packages/` altında yeni bir klasör oluşturulur.
2. `pnpm init` ile package başlatılır.
3. TypeScript yapılandırması ve örnek dosyalar eklenir.
4. Gerekli bağımlılıklar (`typescript`, `@types/react`, `@types/react-dom`) eklenir.
5. `react` ve `react-dom` peer dependency olarak eklenir.
6. Ana `package.json`'a uygun build script'i eklenir.

> Tüm bu adımlar `createComponent` fonksiyonu ile otomatikleştirilmiştir.

## Yeni Web Uygulaması Oluşturma

Yeni bir web uygulaması eklemek için:

1. `apps/` altında yeni bir klasör oluşturulur.
2. `pnpm create vite` ile React + TypeScript template'i başlatılır.
3. Gerekli bağımlılıklar yüklenir.
4. Vite yapılandırması ve örnek `App.tsx` dosyası eklenir.
5. Ana `package.json`'a uygun start script'i eklenir.

> Tüm bu adımlar `createWebapp` fonksiyonu ile otomatikleştirilmiştir.

## Scriptler

Ana dizindeki `package.json` dosyasına, her bileşen ve uygulama için otomatik olarak script'ler eklenir:

- `build:<bileşen-adı>`: İlgili bileşeni derler.
- `start:<uygulama-adı>:ui`: İlgili web uygulamasını başlatır.

Örnek:

```
pnpm run build:comp1
pnpm run start:comp1-app:ui
```

## Notlar
- Bileşenler peer dependency olarak `react` ve `react-dom` bekler, uygulamalar ise bunları doğrudan bağımlılık olarak içerir.
- Tüm işlemler otomatikleştirildiği için yeni bir bileşen veya uygulama eklemek için ilgili fonksiyonları betikte çağırmak yeterlidir.

---

Daha fazla bilgi için `.devcontainer/postcreate.sh` dosyasını inceleyebilirsiniz.
