(function () {
  "use strict";

  const translations = {
    zh: {
      brandAria: "项目协调首页",
      navAria: "主导航",
      languageGroup: "语言",
      navLifecycle: "生命周期",
      navProfiles: "流程档位",
      navSkills: "Skill 组成",
      navInstall: "安装",
      navGithub: "GitHub",
      heroEyebrow: "Codex + Claude Code 仓库级 Skills",
      pageTitle: "项目协调",
      heroLede: "把项目决策、计划、任务、代码质量和验证证据，整理成下一项可验收的工作。",
      heroInstall: "安装到项目",
      heroSource: "查看源码",
      signalAria: "协调契约",
      signalEyebrow: "协调契约",
      signalTitle: "先定范围，再写代码。<br />先有证据，再做验收。",
      signalBody: "从真实的多仓库交付流程中提炼，不绑定具体产品或技术栈。",
      skillsEyebrow: "五个职责清晰的 Skill",
      skillsTitle: "从当前工作线，一直到可验证的交付证据。",
      triageBody: "用决策、计划、任务索引和仓库证据确认主工作线，区分阻塞项、未来工作与待决策事项。",
      coordinationBody: "把已确认方向转成计划与可执行任务，交给新 session 实现，再回到协调 session 独立验收。",
      validationBody: "修改前定义最小可复现验证，区分工具、运行时与端到端证据，并按 lane 组织 live smoke。",
      contractBody: "确认权威契约来源，同步后端、前端、Mock、生成客户端、文档和 SDK 的结构与行为。",
      auditBody: "聚焦 changed files，找出过度兜底、异常掩盖、宽松类型和不必要状态同步等审查候选。",
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
      profilesNote: "安装时选择项目默认档位；每个 tracked task 根据实际风险记录有效档位，可升级也可降级。",
      compactTitle: "Compact",
      compactBody: "局部、低风险改动可以留在一个 session 中，并配合聚焦的验证命令。",
      standardTitle: "Standard",
      standardBody: "后端与前端协作使用任务记录、契约负责人、新执行 session 和协调验收。",
      complexTitle: "Complex",
      complexBody: "多仓库、SDK、并行工作、迁移和外部 gate 使用明确的依赖与发布控制。",
      qualityEyebrow: "随协调包安装",
      qualityTitle: "审查可疑模式，不用扫描结果代替判断。",
      qualityChangedTitle: "聚焦变更",
      qualityChangedBody: "按真实 Git 根检查 changed files，支持 Java、Kotlin、TypeScript、JavaScript、Go 和 Python。",
      qualityClassifyTitle: "人工分类",
      qualityClassifyBody: "识别过度兜底、异常吞噬、空结果掩盖、any、浏览器 token 存储和 React 状态同步候选。",
      qualityEvidenceTitle: "证据分离",
      qualityEvidenceBody: "扫描结果只是 review 输入；编译、测试、运行时和 E2E 证据仍由执行与验收记录负责。",
      installEyebrow: "在项目上下文中开始",
      installTitle: "让 Codex 或 Claude Code 将它安装到项目中。",
      installBody: "安装器只询问项目架构和流程档位。它会发现 Git 根与组件清单，保留已有指令和任务索引，并将五个 skill 同时安装到两个平台目录。",
      installCode: "从本仓库将 project-coordination 安装到：\n\n<目标项目绝对路径>\n\nArchitecture: multi-repo\nWorkflow profile: standard\n\n先阅读 README.md 和安装器。保留已有 AGENTS.md、CLAUDE.md 与 docs/PROJECT_TASKS.md。不要修改业务代码或创建 commit。",
      installLink: "查看完整安装 prompt",
      boundaryEyebrow: "保留在项目本地的内容",
      boundaryTitle: "协调内核，而不是产品模板。",
      boundaryBody: "产品边界、运行启动器、服务拓扑、领域接入、API 约定和项目编码规则都保留在目标仓库中。这组 skill 负责协调这些能力，不替代它们。",
      footerGithub: "GitHub 仓库"
    },
    en: {
      brandAria: "Project Coordination home",
      navAria: "Primary navigation",
      languageGroup: "Language",
      navLifecycle: "Lifecycle",
      navProfiles: "Profiles",
      navSkills: "Skill package",
      navInstall: "Install",
      navGithub: "GitHub",
      heroEyebrow: "Repository-local skills for Codex + Claude Code",
      pageTitle: "Project Coordination",
      heroLede: "Turn a project's decisions, plans, tasks, code quality, and validation evidence into the next acceptable piece of work.",
      heroInstall: "Install into a project",
      heroSource: "View source",
      signalAria: "Coordination contract",
      signalEyebrow: "Coordination contract",
      signalTitle: "Scope before code.<br />Evidence before acceptance.",
      signalBody: "Designed from real multi-repository delivery work, without tying the workflow to a specific product or stack.",
      skillsEyebrow: "Five focused skills",
      skillsTitle: "From the active workstream to verifiable delivery evidence.",
      triageBody: "Confirm the primary workstream from decisions, plans, the task index, and repository evidence while separating blockers, future work, and open decisions.",
      coordinationBody: "Turn approved direction into plans and executable tasks, hand implementation to a fresh session, then return to coordination for independent acceptance.",
      validationBody: "Define the smallest reproducible check before editing, distinguish tooling, runtime, and end-to-end evidence, and coordinate live smoke by lane.",
      contractBody: "Establish the authoritative source, then align structure and behavior across backends, frontends, mocks, generated clients, documentation, and SDKs.",
      auditBody: "Focus on changed files and surface review candidates such as over-defensive fallback, masked errors, loose typing, and unnecessary state synchronization.",
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
      profilesNote: "Installation chooses a project default; each tracked task records an effective profile from its actual risk and may raise or reduce it.",
      compactTitle: "Compact",
      compactBody: "Local, low-risk changes can stay in one session with a focused validation command.",
      standardTitle: "Standard",
      standardBody: "Backend and frontend work uses task records, contract ownership, a fresh execution session, and coordinator acceptance.",
      complexTitle: "Complex",
      complexBody: "Multiple repositories, SDKs, parallel work, migrations, and external gates receive explicit dependency and release controls.",
      qualityEyebrow: "Installed with coordination",
      qualityTitle: "Review suspicious patterns without replacing judgment.",
      qualityChangedTitle: "Focus on changes",
      qualityChangedBody: "Scan changed files from each real Git root across Java, Kotlin, TypeScript, JavaScript, Go, and Python.",
      qualityClassifyTitle: "Classify findings",
      qualityClassifyBody: "Surface over-defensive fallback, swallowed errors, empty-result masking, any, browser token storage, and React state synchronization candidates.",
      qualityEvidenceTitle: "Separate evidence",
      qualityEvidenceBody: "Scanner output is review input; build, test, runtime, and E2E evidence still belongs in execution and acceptance records.",
      installEyebrow: "Start in context",
      installTitle: "Ask Codex or Claude Code to install it into a project.",
      installBody: "The installer only asks for architecture and workflow profile. It discovers Git roots and component manifests, preserves existing instructions and task indexes, and installs all five skills into both platform layouts.",
      installCode: "Install project-coordination from this repository into:\n\n<absolute-target-project-path>\n\nArchitecture: multi-repo\nWorkflow profile: standard\n\nRead README.md and the installer first. Preserve existing AGENTS.md, CLAUDE.md, and docs/PROJECT_TASKS.md. Do not modify business code or create a commit.",
      installLink: "Read the complete installation prompt",
      boundaryEyebrow: "What stays local",
      boundaryTitle: "A coordination kernel, not a product template.",
      boundaryBody: "Product boundaries, runtime launchers, service topology, domain onboarding, API conventions, and project-specific coding rules remain in the target repository. This package coordinates those capabilities; it does not replace them.",
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
