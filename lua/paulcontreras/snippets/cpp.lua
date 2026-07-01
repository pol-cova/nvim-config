-- Competitive programming snippets for C++
-- Note: in fmt(), {{ and }} are LITERAL braces; {} are insert-node placeholders.

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("cpp", {

  -- ─── Full CP template ─────────────────────────────────────────────────────
  s("cp", fmt([[
#include <bits/stdc++.h>
using namespace std;

#define int long long
#define pb push_back
#define eb emplace_back
#define all(x) (x).begin(), (x).end()
#define sz(x) (int)(x).size()
#define F first
#define S second

typedef pair<int,int> pii;
typedef vector<int> vi;
typedef vector<pii> vpi;

const int MOD = 1e9 + 7;
const int INF = 2e18;

void solve() {{
    {}
}}

signed main() {{
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    int tc = 1;
    // cin >> tc;
    while (tc--) solve();
    return 0;
}}]], { i(1, "// solution") })),

  -- ─── Fast I/O ─────────────────────────────────────────────────────────────
  s("fio", t({
    "ios_base::sync_with_stdio(false);",
    "cin.tie(NULL);",
  })),

  -- ─── Debug macro (disabled in online judges) ──────────────────────────────
  s("dbg", fmt([[
#ifdef LOCAL
  #define dbg(...) cerr << "[" << #__VA_ARGS__ << "]: ", _dbg(__VA_ARGS__)
  template<typename T>
  void _dbg(T x) {{ cerr << x << "\n"; }}
  template<typename T, typename... Args>
  void _dbg(T x, Args... args) {{ cerr << x << ", "; _dbg(args...); }}
#else
  #define dbg(...)
#endif]], {})),

  -- ─── Binary search template ───────────────────────────────────────────────
  s("bs", fmt([[
int lo = {lo}, hi = {hi};
while (lo < hi) {{
    int mid = lo + (hi - lo) / 2;
    if ({cond}) hi = mid;
    else lo = mid + 1;
}}
// answer is lo]], {
    lo   = i(1, "0"),
    hi   = i(2, "n"),
    cond = i(3, "check(mid)"),
  })),

  -- ─── Graph: adjacency list input ──────────────────────────────────────────
  s("graph", fmt([[
int n, m;
cin >> n >> m;
vector<vector<int>> adj(n + 1);
for (int k = 0; k < m; k++) {{
    int u, v;
    cin >> u >> v;
    adj[u].pb(v);
    adj[v].pb(u);
}}]], {})),

  -- ─── BFS with distance array ──────────────────────────────────────────────
  -- Uses rep(1) so the push mirrors the dist initialisation node.
  s("bfs", fmt([[
vector<int> dist(n + 1, -1);
queue<int> q;
dist[{}] = 0;
q.push({});
while (!q.empty()) {{
    int u = q.front(); q.pop();
    for (int v : adj[u]) {{
        if (dist[v] == -1) {{
            dist[v] = dist[u] + 1;
            q.push(v);
        }}
    }}
}}]], {
    i(1, "src"),
    rep(1),   -- mirrors the source node above
  })),

  -- ─── DSU / Union-Find ─────────────────────────────────────────────────────
  s("dsu", t({
    "struct DSU {",
    "    vector<int> p, rnk;",
    "    DSU(int n) : p(n), rnk(n, 0) { iota(p.begin(), p.end(), 0); }",
    "    int find(int x) { return p[x] == x ? x : p[x] = find(p[x]); }",
    "    bool unite(int a, int b) {",
    "        a = find(a); b = find(b);",
    "        if (a == b) return false;",
    "        if (rnk[a] < rnk[b]) swap(a, b);",
    "        p[b] = a;",
    "        if (rnk[a] == rnk[b]) rnk[a]++;",
    "        return true;",
    "    }",
    "};",
  })),

  -- ─── Segment tree (iterative, point update, range sum query) ─────────────
  s("seg", t({
    "struct SegTree {",
    "    int n; vector<long long> t;",
    "    SegTree(int n) : n(n), t(2*n, 0) {}",
    "    void update(int i, long long v) {",
    "        for (t[i += n] = v; i > 1; i >>= 1)",
    "            t[i >> 1] = t[i] + t[i ^ 1];",
    "    }",
    "    long long query(int l, int r) { // [l, r)",
    "        long long res = 0;",
    "        for (l += n, r += n; l < r; l >>= 1, r >>= 1) {",
    "            if (l & 1) res += t[l++];",
    "            if (r & 1) res += t[--r];",
    "        }",
    "        return res;",
    "    }",
    "};",
  })),

  -- ─── Modular arithmetic helpers ───────────────────────────────────────────
  s("modpow", t({
    "long long modpow(long long base, long long exp, long long mod) {",
    "    long long result = 1;",
    "    base %= mod;",
    "    while (exp > 0) {",
    "        if (exp & 1) result = result * base % mod;",
    "        base = base * base % mod;",
    "        exp >>= 1;",
    "    }",
    "    return result;",
    "}",
  })),

})
