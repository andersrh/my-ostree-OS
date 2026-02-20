Name:           thunar
Version:        4.20.0
Release:        1%{?dist}
Summary:        Modern file manager for the Xfce Desktop Environment

License:        GPLv2+ and LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/thunar/4.20/thunar-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  exo-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libnotify-devel
BuildRequires:  libexif-devel
BuildRequires:  libpng-devel
BuildRequires:  gudev-devel
BuildRequires:  pinner-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
Thunar is a modern file manager for the Xfce Desktop Environment.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang thunar

%files -f thunar.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/thunar
%{_bindir}/thunar-settings
%{_libdir}/libthunarx-3.so.*
%{_libdir}/Thunar/
%{_datadir}/applications/thunar.desktop
%{_datadir}/applications/thunar-bulk-rename.desktop
%{_datadir}/applications/thunar-settings.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.thunar.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.thunar.svg

%files devel
%{_includedir}/thunarx-3/
%{_libdir}/libthunarx-3.so
%{_libdir}/pkgconfig/thunarx-3.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
