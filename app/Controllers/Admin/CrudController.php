<?php
declare(strict_types=1);
namespace App\Controllers\Admin;

use App\Core\{Auth, Controller, DB, Request};

/** Generisches, konfigurationsgesteuertes CRUD für einfache Inhaltstabellen. */
final class CrudController extends Controller
{
    private const RES = [
        'news' => ['t' => 'website_news', 'title' => 'News', 'perm' => 'housekeeping_website_news', 'icon' => 'newspaper', 'order' => 'timestamp DESC',
            'list' => ['title' => 'Titel', 'category' => 'Kat.', 'hidden' => 'Versteckt', 'timestamp' => ['Datum', 'date']],
            'fields' => [['title', 'Titel', 'text'], ['short_story', 'Kurztext', 'textarea'], ['full_story', 'Text (BBCode: [b] [i] [u] [url=..] [img])', 'textarea', 12], ['header', 'Bild-URL (oder Upload)', 'image'], ['category', 'Kategorie', 'select:news_cats'], ['hidden', 'Versteckt', 'bool']],
            'slug' => 'title', 'defaults' => ['images' => '[]', 'form' => 'none']],
        'news_cats' => ['t' => 'website_news_categories', 'title' => 'News-Kategorien', 'perm' => 'housekeeping_website_news', 'icon' => 'tags', 'order' => 'category',
            'list' => ['category' => 'Name'], 'fields' => [['category', 'Name', 'text']]],
        'faq' => ['t' => 'website_helptool_faq', 'title' => 'FAQ', 'perm' => 'housekeeping_website_faq', 'icon' => 'question-circle', 'order' => 'category, title',
            'list' => ['title' => 'Frage', 'category' => 'Kat.'], 'fields' => [['title', 'Frage', 'text'], ['category', 'Kategorie', 'select:faq_cats'], ['desc', 'Antwort', 'textarea', 8]], 'slug' => 'title'],
        'faq_cats' => ['t' => 'website_helptool_categories', 'title' => 'FAQ-Kategorien', 'perm' => 'housekeeping_website_faq', 'icon' => 'folder', 'order' => 'category',
            'list' => ['category' => 'Name'], 'fields' => [['category', 'Name', 'text']]],
        'jobs' => ['t' => 'website_jobs', 'title' => 'Jobs', 'perm' => 'housekeeping_jobs', 'icon' => 'briefcase', 'order' => 'id',
            'list' => ['job' => 'Job', 'small_description' => 'Kurzbeschreibung'], 'fields' => [['job', 'Jobname', 'text'], ['small_description', 'Kurzbeschreibung', 'text'], ['full_description', 'Beschreibung', 'textarea', 6]]],
        'rares_pages' => ['t' => 'website_rares_pages', 'title' => 'Rare-Seiten', 'perm' => 'housekeeping_website_rarevalue', 'icon' => 'gem', 'order' => 'id',
            'list' => ['name' => 'Name', 'description' => 'Beschreibung'], 'fields' => [['name', 'Name', 'text'], ['description', 'Beschreibung', 'text'], ['thumbnail', 'Bild-URL (oder Upload)', 'image']]],
        'rares' => ['t' => 'website_rares', 'title' => 'Rare-Werte', 'perm' => 'housekeeping_website_rarevalue', 'icon' => 'stars', 'order' => 'parent_id, name',
            'list' => ['name' => 'Name', 'parent_id' => 'Seite', 'cost_credits' => 'Credits', 'cost_points' => 'Diamanten'],
            'fields' => [['name', 'Name', 'text'], ['parent_id', 'Seite', 'select:rares_pages'], ['item_id', 'Item-ID', 'number'], ['image', 'Bild-URL (oder Upload)', 'image'], ['cost_credits', 'Wert in Credits', 'number'], ['cost_points', 'Wert in Diamanten', 'number'], ['points_type', 'Punkte-Typ', 'number']],
            'defaults' => ['last_editor' => 0]],
        'ban_types' => ['t' => 'website_ban_types', 'title' => 'Bann-Dauern', 'perm' => 'housekeeping_ban_user', 'icon' => 'hourglass-split', 'order' => 'seconds',
            'list' => ['message' => 'Bezeichnung', 'seconds' => 'Sekunden', 'min_rank' => 'Min. Rang'], 'fields' => [['message', 'Bezeichnung', 'text'], ['seconds', 'Sekunden', 'number'], ['min_rank', 'Mindest-Rang', 'number']]],
        'offers' => ['t' => 'website_paypal_offers', 'title' => 'Shop-Angebote', 'perm' => 'housekeeping_shop_offers', 'icon' => 'bag', 'order' => 'id',
            'list' => ['title' => 'Titel', 'price' => 'Preis'], 'fields' => [['title', 'Titel', 'text'], ['price', 'Preis', 'text'], ['image', 'Bild-URL (oder Upload)', 'image'], ['description', 'Beschreibung', 'textarea', 4], ['data', 'Daten (JSON, z. B. {"points":100})', 'textarea', 3]]],
        'topics' => ['t' => 'ares_forum_topics', 'title' => 'Forum-Bereiche', 'perm' => 'housekeeping_forum', 'icon' => 'chat-square-text', 'order' => 'sort',
            'list' => ['title' => 'Titel', 'sort' => 'Sortierung', 'min_rank' => 'Min. Rang'], 'fields' => [['title', 'Titel', 'text'], ['description', 'Beschreibung', 'text'], ['sort', 'Sortierung', 'number'], ['min_rank', 'Mindest-Rang zum Lesen', 'number']], 'slug' => 'title', 'created' => 'created_at'],
        'extra_ranks' => ['t' => 'website_extra_ranks', 'title' => 'Extra-Ränge', 'perm' => 'housekeeping_ranks_extra', 'icon' => 'award', 'order' => 'id',
            'list' => ['rank_name' => 'Name', 'rank_description' => 'Beschreibung'], 'fields' => [['rank_name', 'Name', 'text'], ['rank_description', 'Beschreibung', 'text']]],
        'currencies' => ['t' => 'website_settings_currencys', 'title' => 'Währungen', 'perm' => 'housekeeping_config', 'icon' => 'coin', 'order' => 'id',
            'list' => ['currency' => 'Name', 'type' => 'Typ-ID'], 'fields' => [['currency', 'Name', 'text'], ['type', 'Typ-ID (Emulator)', 'number'], ['amount', 'Anzeigewert', 'number']]],
    ];

    public static function resources(): array { return self::RES; }

    private function res(string $k): array
    {
        $r = self::RES[$k] ?? null;
        if (!$r) $this->abort(404);
        if (!Auth::can($r['perm'])) $this->abort(403);
        $r['key'] = $k;
        return $r;
    }

    private function options(string $src): array
    {
        return match ($src) {
            'news_cats' => DB::all('SELECT id, category AS label FROM website_news_categories ORDER BY category'),
            'faq_cats' => DB::all('SELECT id, category AS label FROM website_helptool_categories ORDER BY category'),
            'rares_pages' => DB::all('SELECT id, name AS label FROM website_rares_pages ORDER BY name'),
            default => [],
        };
    }

    public function index(string $k): void
    {
        $r = $this->res($k);
        $rows = DB::all("SELECT * FROM `{$r['t']}` ORDER BY {$r['order']} LIMIT 500");
        $this->view('admin/crud_list', ['title' => $r['title'], 'r' => $r, 'rows' => $rows], 'admin');
    }

    public function form(string $k, ?string $id = null): void
    {
        $r = $this->res($k);
        $row = $id !== null ? DB::one("SELECT * FROM `{$r['t']}` WHERE id=?", [(int)$id]) : null;
        if ($id !== null && !$row) $this->abort(404);
        $opts = [];
        foreach ($r['fields'] as $f) if (str_starts_with($f[2], 'select:')) $opts[$f[0]] = $this->options(substr($f[2], 7));
        $this->view('admin/crud_form', ['title' => ($row ? 'Bearbeiten: ' : 'Neu: ') . $r['title'], 'r' => $r, 'row' => $row, 'opts' => $opts], 'admin');
    }

    public function save(string $k): void
    {
        $r = $this->res($k);
        $id = Request::int('id');
        $data = [];
        foreach ($r['fields'] as $f) {
            [$name, , $type] = $f;
            if ($type === 'bool') { $data[$name] = isset($_POST[$name]) ? '1' : '0'; continue; }
            if ($type === 'image') {
                $up = $this->upload($name . '_file', $k);
                $data[$name] = $up ?? Request::str($name, 255);
                if ($data[$name] !== '' && !preg_match('~^(https?://|/)~', $data[$name])) $this->fail('Ungültige Bild-URL.');
                continue;
            }
            $v = (string)($_POST[$name] ?? '');
            $data[$name] = str_starts_with($type, 'select:') || $type === 'number' ? (int)$v : mb_substr(trim($v), 0, $type === 'textarea' ? 65000 : 255);
        }
        if ($id) {
            DB::update($r['t'], $data, 'id=?', [$id]);
            log_staff('CRUD_UPDATE', $r['title'] . " #$id");
        } else {
            if (!empty($r['slug'])) {
                $s = slugify((string)$data[$r['slug']]); $base = $s; $i = 1;
                while (DB::val("SELECT 1 FROM `{$r['t']}` WHERE slug=?", [$s])) $s = $base . '-' . (++$i);
                $data['slug'] = $s;
            }
            $data += $r['defaults'] ?? [];
            if (in_array($k, ['news', 'faq'], true)) { $data['timestamp'] = time(); $data['author'] = Auth::user()['id']; }
            if (!empty($r['created'])) $data[$r['created']] = time();
            $id = DB::insert($r['t'], $data);
            log_staff('CRUD_CREATE', $r['title'] . " #$id");
        }
        flash('success', 'Gespeichert.');
        redirect('/admin/c/' . $k);
    }

    public function delete(string $k, string $id): void
    {
        $r = $this->res($k);
        DB::delete($r['t'], 'id=?', [(int)$id]);
        log_staff('CRUD_DELETE', $r['title'] . " #$id");
        flash('success', 'Gelöscht.');
        redirect('/admin/c/' . $k);
    }
}
