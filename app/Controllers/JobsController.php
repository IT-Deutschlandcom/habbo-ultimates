<?php
declare(strict_types=1);
namespace App\Controllers;

use App\Core\{Auth, Controller, DB, Request};

final class JobsController extends Controller
{
    public function index(): void
    {
        $mine = Auth::check() ? array_column(DB::all('SELECT job_id FROM website_jobs_applys WHERE user_id=?', [Auth::user()['id']]), 'job_id') : [];
        $this->view('jobs/index', ['title' => 'Jobs', 'jobs' => DB::all('SELECT * FROM website_jobs ORDER BY id'), 'mine' => $mine]);
    }

    public function applyForm(int $id): void
    {
        $j = DB::one('SELECT * FROM website_jobs WHERE id=?', [$id]);
        if (!$j) $this->abort(404);
        $this->view('jobs/apply', ['title' => 'Bewerbung: ' . $j['job'], 'j' => $j]);
    }

    public function apply(int $id): void
    {
        $j = DB::one('SELECT * FROM website_jobs WHERE id=?', [$id]);
        if (!$j) $this->abort(404);
        $uid = Auth::user()['id'];
        if (DB::val('SELECT 1 FROM website_jobs_applys WHERE job_id=? AND user_id=?', [$id, $uid])) $this->fail('Du hast dich bereits beworben.', '/jobs');
        $msg = Request::str('message', 3000); $first = Request::str('firstname', 50);
        if (mb_strlen($msg) < 20 || $first === '') $this->fail('Bitte fülle Vorname und eine ausführliche Nachricht aus.');
        $d = ['job_id' => $id, 'user_id' => $uid, 'firstname' => $first, 'message' => $msg, 'status' => 'open'];
        foreach (['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'] as $day) $d['available_' . $day] = Request::str($day, 50);
        DB::insert('website_jobs_applys', $d);
        flash('success', 'Bewerbung abgeschickt!');
        redirect('/jobs');
    }
}
