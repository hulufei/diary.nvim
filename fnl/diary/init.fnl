(local {: autoload} (require :diary.nfnl.module))
(local core (autoload :diary.nfnl.core))
(local fs (autoload :diary.nfnl.fs))

(local config {:diary-dir "~/diary/"})

(fn member? [val list]
  ((core.complement core.empty?)
    (core.filter #(= $1 val) list)))

(macro tab-open [get-win do-in-memo-tab do-for-newtab]
  `(let [memo-tab-win# ,get-win]
     (if memo-tab-win# 
       (do
         (vim.fn.win_gotoid memo-tab-win#)
         ,do-in-memo-tab)
       (do
         ,do-for-newtab))))

(fn list-bufs-match [test]
  (icollect [_ buf (ipairs (vim.api.nvim_list_bufs))]
              (if (and (vim.api.nvim_buf_is_loaded buf)
                       (test buf))
                buf)))

(fn list-bufs-match-dir [path]
  (list-bufs-match (fn [buf]
                     (string.find (vim.api.nvim_buf_get_name buf) path 1 true))))

(fn filter-current-tab-wins [wins]
  ;; Buffer may be loaded in different wins, make sure we get the wins in another tab
  ;;
  ;; TOIMPROVE: If there are multiple other tabs contain target buffer, then which one
  ;; tab will active is unpredictable. (:drop seems to solve the problem partly)
  (local current-wins (vim.api.nvim_tabpage_list_wins 0))
  (icollect [_ win (ipairs wins)]
    (if (member? win current-wins) nil win)))

(fn list-wins-with-bufs [bufs]
  (if (unpack bufs)
    (icollect [_ win (ipairs (vim.api.nvim_list_wins))]
      (if (and (vim.api.nvim_win_is_valid win)
               (member? (vim.api.nvim_win_get_buf win) bufs))
        win))
    []))

(fn get-win-match-dir [path]
  (local path (vim.fn.expand path))
  (local bufs (list-bufs-match-dir path))
  (unpack (filter-current-tab-wins (list-wins-with-bufs bufs))))

(fn tab-view-diary [filename]
  (let [diary (.. config.diary-dir filename)]
    (tab-open (get-win-match-dir config.diary-dir)
              (vim.cmd.edit diary)
              (do
                (vim.cmd.tabnew diary)
                (vim.cmd.tcd config.diary-dir)))))

(fn tab-new-diary []
  (let [diary (.. (os.date "%Y-%m-%d") ".md")]
    (tab-view-diary diary)))

(fn get-diary-file-list []
  (icollect [name type (vim.fs.dir config.diary-dir)]
    (if (and (= type "file")
             (string.match name "^%d%d%d%d%-%d%d%-%d%d%.md$"))
      name)))

(fn review-random-diary []
  (let [diary-files (get-diary-file-list)
        rand-index (math.random (length diary-files))
        rand-diary (. diary-files rand-index)]
    (tab-view-diary rand-diary)))

(fn find-yesterday-once-more-diary []
  (let [pattern (string.gsub (os.date "%m-%d") "%-" "%%-")]
    (icollect [_ diary (ipairs (get-diary-file-list))]
      (if (string.match diary pattern) diary))))

(fn gen-location-list [filenames]
  (icollect [_ filename (ipairs filenames)]
    (let [diary (.. config.diary-dir filename)]
      {:filename diary
       :lnum 0
       :col 0
       :text (fs.read-first-line diary)})))

(fn review-yesterday-once-more []
  (let [matched-diaries (find-yesterday-once-more-diary)]
    (match (length matched-diaries)
      0 nil
      1 (tab-view-diary (core.first matched-diaries))
      _ (do
          (vim.fn.setloclist 0 (gen-location-list matched-diaries))
          (vim.cmd.lopen)))))

(fn group-diary []
  (local results {})
  (each [_ diary (ipairs (get-diary-file-list))]
    (let [[year month] (vim.split diary "-")]
      (when (not (. results year))
        (tset results year {}))
      (when (not (. results year month))
        (tset results year month []))
      (table.insert (. results year month) diary)))
  results)

(fn desc-strnum [xs]
  (table.sort xs #(> (tonumber $1) (tonumber $2)))
  xs)

(fn parse-diary-day [diary]
  (tonumber (string.match diary "(%d%d)%.md$")))

(fn desc-diary-monthly [xs]
  (table.sort xs #(> (parse-diary-day $1) (parse-diary-day $2)))
  xs)

(fn write-diary-index []
  (let [group (group-diary)
        outfile "index.md"]
    (with-open [fout (io.open (.. config.diary-dir outfile) :w)]
      (fout:write "# Diary\n\n")
      (each [_ year (ipairs (desc-strnum (core.keys group)))]
        (fout:write (.. "## " year "\n\n"))
        (each [_ month (ipairs (desc-strnum (core.keys (. group year))))]
          (let [full-month-name (os.date "%B" (os.time {: year : month :day 1}))]
            (fout:write (.. "### " full-month-name "\n\n"))
            (each [_ diary (ipairs (desc-diary-monthly (. group year month)))]
              (let [first-line (fs.read-first-line (.. config.diary-dir diary))
                    title (string.match first-line "^#+%s+(.+)")]
                (fout:write
                  (.. "- [" 
                      (or title (vim.fn.trim diary ".md" 2))
                      "]("
                      diary
                      ")\n"))))
            (fout:write "\n")))))
    (tab-view-diary outfile)))

(fn setup [opts]
  (when opts.diary-dir
    (set config.diary-dir
         (.. (vim.fs.normalize opts.diary-dir) "/")))
  (vim.api.nvim_create_user_command :DiaryNew tab-new-diary {})
  (vim.api.nvim_create_user_command :DiaryReviewRandom review-random-diary {})
  (vim.api.nvim_create_user_command :YesterdayOnceMore review-yesterday-once-more {})
  (vim.api.nvim_create_user_command :DiaryGenerateLinks write-diary-index {}))

{: setup }
