FROM node:20-alpine as base

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係のインストール
FROM base as deps
COPY package.json yarn.lock ./
RUN yarn install

# ビルド
FROM base as build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

# 本番環境
FROM base as production
ENV NODE_ENV=production

# 必要なファイルをコピー
COPY --from=build /app/build ./build
COPY --from=build /app/public ./public
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./

# アプリケーションを起動
CMD ["yarn", "start"]

# ポートを公開
EXPOSE 3000
