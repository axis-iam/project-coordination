(function () {
  "use strict";

  const translations = {
    zh: {
      brandAria: "项目协调首页",
      navAria: "主导航",
      languageGroup: "语言",
      navLifecycle: "生命周期",
      navProfiles: "流程档位",
      navInstall: "安装",
      navGithub: "GitHub",
      heroEyebrow: "仓库级 Codex skill",
      pageTitle: "项目协调",
      heroLede: "把项目决策、任务、代码状态和验证证据，整理成下一项可验证的工作。",
      heroInstall: "使用 Codex 安装",
      heroSource: "查看源码",
      signalAria: "协调契约",
      signalEyebrow: "协调契约",
      signalTitle: "先定范围，再写代码。<br />先有证据，再做验收。",
      signalBody: "从真实的多仓库交付流程中提炼，不绑定具体产品或技术栈。",
      lifecycleEyebrow: "核心规则",
      lifecycleTitle: "分离协调、执行与验收。",
      stepOneTitle: "协调",
      stepOneBody: "创建权威任务，解决依赖，分配 worktree，声明验证 harness，并生成交接 prompt。",
      stepTwoTitle: "在新 session 中执行",
      stepTwoBody: "只实现声明范围，运行 harness，回写执行记录。不暗中扩大范围，也不自行验收。",
      stepThreeTitle: "独立验收",
      stepThreeBody: "回到协调 session，检查 diff、证据、依赖和消费者契约后，再记录验收结果。",
      profilesEyebrow: "按规模启用流程",
      profilesTitle: "只使用工作真正需要的流程。",
      compactTitle: "Compact",
      compactBody: "局部、低风险改动可以留在一个 session 中，并配合聚焦的验证命令。",
      standardTitle: "Standard",
      standardBody: "后端与前端协作使用任务记录、契约负责人、新执行 session 和协调验收。",
      complexTitle: "Complex",
      complexBody: "多仓库、SDK、并行工作、迁移和外部 gate 使用明确的依赖与发布控制。",
      installEyebrow: "在项目上下文中开始",
      installTitle: "让 Codex 将它安装到项目中。",
      installBody: "安装器只询问项目架构和流程档位。它会发现 Git 根与组件清单，保留已有指令和任务索引，并将项目专属能力 skill 留在协调包之外。",
      installCode: "从本仓库将 project-coordination 安装到：\n\n<目标项目绝对路径>\n\nArchitecture: multi-repo\nWorkflow profile: standard\n\n先阅读 README.md 和安装器。保留已有 AGENTS.md 与 docs/PROJECT_TASKS.md。不要修改业务代码或创建 commit。",
      installLink: "查看完整安装 prompt",
      boundaryEyebrow: "保留在项目本地的内容",
      boundaryTitle: "协调内核，而不是产品模板。",
      boundaryBody: "产品边界、运行启动器、服务拓扑、领域接入、API 约定和项目编码规则都保留在目标仓库中。这个 skill 负责协调这些能力，不替代它们。",
      footerGithub: "GitHub 仓库"
    },
    en: {
      brandAria: "Project Coordination home",
      navAria: "Primary navigation",
      languageGroup: "Language",
      navLifecycle: "Lifecycle",
      navProfiles: "Profiles",
      navInstall: "Install",
      navGithub: "GitHub",
      heroEyebrow: "Repository-local Codex skill",
      pageTitle: "Project Coordination",
      heroLede: "Turn a project’s decisions, tasks, code state, and validation evidence into the next verified piece of work.",
      heroInstall: "Install with Codex",
      heroSource: "View source",
      signalAria: "Coordination contract",
      signalEyebrow: "Coordination contract",
      signalTitle: "Scope before code.<br />Evidence before acceptance.",
      signalBody: "Designed from real multi-repository delivery work, without tying the workflow to a specific product or stack.",
      lifecycleEyebrow: "The central rule",
      lifecycleTitle: "Separate coordination, execution, and acceptance.",
      stepOneTitle: "Coordinate",
      stepOneBody: "Create the canonical task, resolve dependencies, assign worktrees, declare the validation harness, and produce a handoff prompt.",
      stepTwoTitle: "Execute in a fresh session",
      stepTwoBody: "Implement only the declared scope, run the harness, and append an execution record. Do not silently expand work or self-accept.",
      stepThreeTitle: "Accept independently",
      stepThreeBody: "Return to coordination to check diff, evidence, dependencies, and consumer contracts before recording acceptance.",
      profilesEyebrow: "Scale the process",
      profilesTitle: "Use only the amount of process the work needs.",
      compactTitle: "Compact",
      compactBody: "Local, low-risk changes can stay in one session with a focused validation command.",
      standardTitle: "Standard",
      standardBody: "Backend and frontend work uses task records, contract ownership, a fresh execution session, and coordinator acceptance.",
      complexTitle: "Complex",
      complexBody: "Multiple repositories, SDKs, parallel work, migrations, and external gates receive explicit dependency and release controls.",
      installEyebrow: "Start in context",
      installTitle: "Ask Codex to install it into a project.",
      installBody: "The installer only asks for architecture and workflow profile. It discovers Git roots and component manifests, preserves existing instructions and task indexes, and keeps project-specific capability skills outside the coordination package.",
      installCode: "Install project-coordination from this repository into:\n\n<absolute-target-project-path>\n\nArchitecture: multi-repo\nWorkflow profile: standard\n\nRead README.md and the installer first. Preserve existing AGENTS.md and docs/PROJECT_TASKS.md. Do not modify business code or create a commit.",
      installLink: "Read the complete installation prompt",
      boundaryEyebrow: "What stays local",
      boundaryTitle: "A coordination kernel, not a product template.",
      boundaryBody: "Product boundaries, runtime launchers, service topology, domain onboarding, API conventions, and project-specific coding rules remain in the target repository. This skill coordinates those capabilities; it does not replace them.",
      footerGithub: "GitHub repository"
    }
  };

  function getInitialLanguage() {
    try {
      const stored = window.localStorage.getItem("project-coordination-language");
      if (stored === "zh" || stored === "en") return stored;
    } catch (_) {
      // Storage can be unavailable in a locked-down browser context.
    }
    return navigator.language && navigator.language.toLowerCase().startsWith("zh") ? "zh" : "en";
  }

  function setLanguage(language) {
    const dictionary = translations[language];
    if (!dictionary) return;

    document.documentElement.lang = language === "zh" ? "zh-CN" : "en";
    document.title = language === "zh" ? "项目协调 | axis-iam" : "Project Coordination | axis-iam";

    document.querySelectorAll("[data-i18n]").forEach(function (element) {
      const value = dictionary[element.dataset.i18n];
      if (typeof value !== "string") return;
      if (element.dataset.i18nMode === "html") {
        element.innerHTML = value;
      } else {
        element.textContent = value;
      }
    });

    document.querySelectorAll("[data-i18n-attr]").forEach(function (element) {
      element.dataset.i18nAttr.split(",").forEach(function (mapping) {
        const parts = mapping.split(":");
        const value = dictionary[parts[1]];
        if (parts.length === 2 && typeof value === "string") element.setAttribute(parts[0], value);
      });
    });

    document.querySelectorAll("[data-language]").forEach(function (button) {
      const active = button.dataset.language === language;
      button.classList.toggle("active", active);
      button.setAttribute("aria-pressed", String(active));
    });

    try {
      window.localStorage.setItem("project-coordination-language", language);
    } catch (_) {
      // The page remains usable without persistence.
    }
  }

  document.querySelectorAll("[data-language]").forEach(function (button) {
    button.addEventListener("click", function () {
      setLanguage(button.dataset.language);
    });
  });

  setLanguage(getInitialLanguage());
})();
